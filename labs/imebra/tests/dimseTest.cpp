#include <imebra/imebra.h>
#include <gtest/gtest.h>
#include <thread>
#include <chrono>
#include <array>
#include <list>
#include <stdio.h>

#ifndef DISABLE_DIMSE_INTEROPERABILITY_TEST
    #include <dirent.h>
    #include <sys/stat.h>
#endif

namespace imebra
{

namespace tests
{

///////////////////////////////////////////////////////////
//
// A SCP that responds to C-STORE commands
//
///////////////////////////////////////////////////////////
void storeScpThread(
        const std::string& name,
        PresentationContexts& presentationContexts,
        StreamReader& readSCP,
        StreamWriter& writeSCP,
        std::list<std::shared_ptr<CStoreCommand> >& receivedCommands)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        DimseService dimseService(scp);

        std::shared_ptr<CStoreCommand> command(dynamic_cast<CStoreCommand*>(dimseService.getCommand()));
        receivedCommands.push_back(command);

        dimseService.sendCommandOrResponse(CStoreResponse(*command, dimseStatusCode_t::success));

    }
    catch(const StreamClosedError&)
    {

    }
}


///////////////////////////////////////////////////////////
//
// Store SCU test
//
// This test sends a DataSet to a SCP which logs all the
// received commands, then checks that the sent dataset
// is in the logged commands.
//
///////////////////////////////////////////////////////////
TEST(dimseTest, storeSCUSCP)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.1.1");
    context.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    std::list<std::shared_ptr<CStoreCommand> > receivedCommands;

    std::thread thread(
                imebra::tests::storeScpThread,
                std::ref(scpName),
                std::ref(presentationContexts),
                std::ref(readSCP),
                std::ref(writeSCP),
                std::ref(receivedCommands));

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);

    DimseService dimse(scu);

    DataSet payload("1.2.840.10008.1.2");
    payload.setString(TagId(tagId_t::SOPClassUID_0008_0016), "1.1.1.1.1");
    payload.setString(TagId(tagId_t::SOPInstanceUID_0008_0018), "1.1.1.1.2");
    payload.setString(TagId(tagId_t::PatientName_0010_0010), "Test^Patient");
    CStoreCommand storeCommand(
                "1.2.840.10008.1.1",
                dimse.getNextCommandID(),
                dimseCommandPriority_t::medium,
                payload.getString(TagId(tagId_t::SOPClassUID_0008_0016), 0),
                payload.getString(TagId(tagId_t::SOPInstanceUID_0008_0018), 0),
                "Origin",
                0,
                payload);
    dimse.sendCommandOrResponse(storeCommand);
    std::unique_ptr<CStoreResponse> response(dimse.getCStoreResponse(storeCommand));

    EXPECT_EQ(1u, receivedCommands.size());
    EXPECT_EQ("Origin", receivedCommands.front()->getOriginatorAET());
    EXPECT_EQ("1.1.1.1.2", receivedCommands.front()->getAffectedSopInstanceUid());
    EXPECT_EQ("1.1.1.1.1", receivedCommands.front()->getAffectedSopClassUid());
    std::unique_ptr<imebra::DataSet> pPayload(receivedCommands.front()->getPayloadDataSet());
    EXPECT_EQ("Test^Patient", pPayload->getString(TagId(tagId_t::PatientName_0010_0010), 0));

    thread.join();
}




///////////////////////////////////////////////////////////
//
// A SCP that responds to C-GET commands.
// It only accepts "PATIENT" query levels and only
// respond to the patient ID "100"
//
///////////////////////////////////////////////////////////
void getScpThread(
        const std::string& name,
        PresentationContexts& presentationContexts,
        StreamReader& readSCP,
        StreamWriter& writeSCP)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        DimseService dimseService(scp);

        for(;;)
        {
            std::unique_ptr<CGetCommand> command(dynamic_cast<CGetCommand*>(dimseService.getCommand()));
            std::unique_ptr<DataSet> pIdentifier(command->getPayloadDataSet());

            if(pIdentifier->getString(TagId(tagId_t::QueryRetrieveLevel_0008_0052), 0) != "PATIENT" ||
                    pIdentifier->getString(TagId(tagId_t::PatientID_0010_0020), 0) != "100")
            {
                dimseService.sendCommandOrResponse(CGetResponse(*command, dimseStatusCode_t::success, 0, 0, 0, 0));
                return;
            }

            // Return a partial response
            dimseService.sendCommandOrResponse(CGetResponse(*command, dimseStatusCode_t::pending, 1, 0, 0, 0));

            // Perform a C-STORE on the AE that requested the C-GET
            std::string abstractSyntax(command->getAbstractSyntax());
            DataSet storePayload(dimseService.getTransferSyntax(abstractSyntax));
            storePayload.setString(TagId(tagId_t::PatientID_0010_0020), "100");
            storePayload.setString(TagId(tagId_t::PatientName_0010_0010), "TEST^PATIENT");
            CStoreCommand storeCommand(
                        abstractSyntax,
                        dimseService.getNextCommandID(),
                        dimseCommandPriority_t::medium,
                        command->getAffectedSopClassUid(),
                        "1.2.3.4.5.6",
                        scp.getOtherAET(),
                        command->getID(),
                        storePayload);

            dimseService.sendCommandOrResponse(storeCommand);
            std::unique_ptr<CStoreResponse> pStoreResponse(dimseService.getCStoreResponse(storeCommand));

            // Send the C-GET final response
            if(pStoreResponse->getStatus() == dimseStatus_t::success)
            {
                dimseService.sendCommandOrResponse(CGetResponse(*command, dimseStatusCode_t::success, 0, 1, 0, 0));
            }
            else
            {
                dimseService.sendCommandOrResponse(CGetResponse(*command, dimseStatusCode_t::subOperationCompletedWithErrors, 0, 0, 1, 0));
            }
        }
    }
    catch(const StreamClosedError&)
    {

    }
}


///////////////////////////////////////////////////////////
//
// Get SCU test
//
// This test requests a C-GET to a SCP, and wait for the
// SCP C-STORE operation and the C-GET responses.
//
///////////////////////////////////////////////////////////
TEST(dimseTest, getSCUSCP)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.5.1.4.1.2.1.3", true, true);
    context.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    std::thread thread(
                imebra::tests::getScpThread,
                std::ref(scpName),
                std::ref(presentationContexts),
                std::ref(readSCP),
                std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);
    DimseService dimse(scu);

    DataSet keys(dimse.getTransferSyntax("1.2.840.10008.5.1.4.1.2.1.3"));
    keys.setString(TagId(tagId_t::QueryRetrieveLevel_0008_0052), "PATIENT");
    keys.setString(TagId(tagId_t::PatientID_0010_0020), "100");
    CGetCommand getCommand(
                "1.2.840.10008.5.1.4.1.2.1.3",
                dimse.getNextCommandID(),
                dimseCommandPriority_t::medium,
                "1.1.1.1.1",
                keys);

    dimse.sendCommandOrResponse(getCommand);

    // Wait for incoming c-store
    std::unique_ptr<CStoreCommand> pStoreCommand(dynamic_cast<CStoreCommand*>(dimse.getCommand()));

    std::unique_ptr<DataSet> pStoreDataSet(pStoreCommand->getPayloadDataSet());

    std::string patientId(pStoreDataSet->getString(TagId(tagId_t::PatientID_0010_0020), 0));
    std::string patientName(pStoreDataSet->getString(TagId(tagId_t::PatientName_0010_0010), 0));

    EXPECT_EQ("100", patientId);
    EXPECT_EQ("TEST^PATIENT", patientName);

    dimse.sendCommandOrResponse(CStoreResponse(*pStoreCommand, dimseStatusCode_t::success));

    std::unique_ptr<CGetResponse> response0(dimse.getCGetResponse(getCommand));
    EXPECT_EQ(dimseStatus_t::pending, response0->getStatus());
    std::unique_ptr<CGetResponse> response1(dimse.getCGetResponse(getCommand));
    EXPECT_EQ(dimseStatus_t::success, response1->getStatus());

    toSCU.terminate();
    toSCP.terminate();
    thread.join();
}


///////////////////////////////////////////////////////////
//
// A SCP that responds to C-MOVE commands.
// It only accepts "PATIENT" query levels and only
// respond to the patient ID "100"
//
///////////////////////////////////////////////////////////
void moveScpThread(
        const std::string& name,
        PresentationContexts& presentationContexts,
        StreamReader& readSCP,
        StreamWriter& writeSCP,
        std::size_t* pReceivedRequests)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        DimseService dimseService(scp);

        for(;;)
        {
            std::unique_ptr<CMoveCommand> command(dynamic_cast<CMoveCommand*>(dimseService.getCommand()));
            std::unique_ptr<DataSet> pIdentifier(command->getPayloadDataSet());

            if(pIdentifier->getString(TagId(tagId_t::QueryRetrieveLevel_0008_0052), 0) != "PATIENT" ||
                    pIdentifier->getString(TagId(tagId_t::PatientID_0010_0020), 0) != "100")
            {
                dimseService.sendCommandOrResponse(CMoveResponse(*command, dimseStatusCode_t::success, 0, 0, 0, 0));
                return;
            }

            (*pReceivedRequests)++;

            // Return a partial response
            dimseService.sendCommandOrResponse(CMoveResponse(*command, dimseStatusCode_t::pending, 1, 0, 0, 0));

            dimseService.sendCommandOrResponse(CMoveResponse(*command, dimseStatusCode_t::success, 0, 1, 0, 0));
        }
    }
    catch(const StreamClosedError&)
    {

    }
}


///////////////////////////////////////////////////////////
//
// Move SCU test
//
// This test requests a C-MOVE to a SCP, and wait for the
// C-MOVE responses.
//
///////////////////////////////////////////////////////////
TEST(dimseTest, moveSCUSCP)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.5.1.4.1.2.1.2");
    context.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    size_t receivedRequests(0);
    std::thread thread(
                imebra::tests::moveScpThread,
                std::ref(scpName),
                std::ref(presentationContexts),
                std::ref(readSCP),
                std::ref(writeSCP),
                &receivedRequests);

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);
    DimseService dimse(scu);



    DataSet keys(dimse.getTransferSyntax("1.2.840.10008.5.1.4.1.2.1.2"));
    keys.setString(TagId(tagId_t::QueryRetrieveLevel_0008_0052), "PATIENT");
    keys.setString(TagId(tagId_t::PatientID_0010_0020), "100");
    CMoveCommand getCommand(
                "1.2.840.10008.5.1.4.1.2.1.2",
                dimse.getNextCommandID(),
                dimseCommandPriority_t::medium,
                "1.1.1.1.1",
                "Destination",
                keys);

    dimse.sendCommandOrResponse(getCommand);

    std::unique_ptr<CMoveResponse> response0(dimse.getCMoveResponse(getCommand));
    EXPECT_EQ(dimseStatus_t::pending, response0->getStatus());
    std::unique_ptr<CMoveResponse> response1(dimse.getCMoveResponse(getCommand));
    EXPECT_EQ(dimseStatus_t::success, response1->getStatus());

    toSCU.terminate();
    toSCP.terminate();
    thread.join();

    EXPECT_EQ(1u, receivedRequests);
}


///////////////////////////////////////////////////////////
//
// A SCP that responds to C-FIND commands.
// It returns 2 studies.
//
///////////////////////////////////////////////////////////
void findScpThread(
        const std::string& name,
        PresentationContexts& presentationContexts,
        StreamReader& readSCP,
        StreamWriter& writeSCP)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        DimseService dimseService(scp);

        for(;;)
        {
            std::unique_ptr<CFindCommand> command(dynamic_cast<CFindCommand*>(dimseService.getCommand()));
            std::unique_ptr<DataSet> pIdentifier(command->getPayloadDataSet());

            if(pIdentifier->getString(TagId(tagId_t::QueryRetrieveLevel_0008_0052), 0) != "STUDY" ||
                    pIdentifier->getString(TagId(tagId_t::PatientID_0010_0020), 0) != "100")
            {
                dimseService.sendCommandOrResponse(CFindResponse(*command, dimseStatusCode_t::success));
                return;
            }

            DataSet study0(dimseService.getTransferSyntax(command->getAbstractSyntax()));
            study0.setString(TagId(tagId_t::PatientID_0010_0020), "100");
            study0.setString(TagId(tagId_t::StudyID_0020_0010), "110");
            dimseService.sendCommandOrResponse(CFindResponse(*command, study0));

            DataSet study1(dimseService.getTransferSyntax(command->getAbstractSyntax()));
            study1.setString(TagId(tagId_t::PatientID_0010_0020), "100");
            study1.setString(TagId(tagId_t::StudyID_0020_0010), "120");
            dimseService.sendCommandOrResponse(CFindResponse(*command, study1));

            dimseService.sendCommandOrResponse(CFindResponse(*command, dimseStatusCode_t::success));
        }
    }
    catch(const StreamClosedError&)
    {

    }
}


///////////////////////////////////////////////////////////
//
// Find SCU test
//
// This test requests a C-FIND to a SCP, and wait for the
// C-FIND responses.
//
///////////////////////////////////////////////////////////
TEST(dimseTest, findSCUSCP)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.5.1.4.1.2.1.1");
    context.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    std::thread thread(
                imebra::tests::findScpThread,
                std::ref(scpName),
                std::ref(presentationContexts),
                std::ref(readSCP),
                std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);
    DimseService dimse(scu);

    DataSet keys(dimse.getTransferSyntax("1.2.840.10008.5.1.4.1.2.1.1"));
    keys.setString(TagId(tagId_t::QueryRetrieveLevel_0008_0052), "STUDY");
    keys.setString(TagId(tagId_t::PatientID_0010_0020), "100");
    CFindCommand findCommand(
                "1.2.840.10008.5.1.4.1.2.1.1",
                dimse.getNextCommandID(),
                dimseCommandPriority_t::medium,
                "1.1.1.1.1",
                keys);

    dimse.sendCommandOrResponse(findCommand);

    std::unique_ptr<CFindResponse> response0(dimse.getCFindResponse(findCommand));
    EXPECT_EQ(dimseStatus_t::pending, response0->getStatus());
    std::unique_ptr<DataSet> dataset0(response0->getPayloadDataSet());
    EXPECT_EQ("110", dataset0->getString(TagId(tagId_t::StudyID_0020_0010), 0));

    std::unique_ptr<CFindResponse> response1(dimse.getCFindResponse(findCommand));
    EXPECT_EQ(dimseStatus_t::pending, response1->getStatus());
    std::unique_ptr<DataSet> dataset1(response1->getPayloadDataSet());
    EXPECT_EQ("120", dataset1->getString(TagId(tagId_t::StudyID_0020_0010), 0));

    std::unique_ptr<CFindResponse> response2(dimse.getCFindResponse(findCommand));
    EXPECT_EQ(dimseStatus_t::success, response2->getStatus());

    toSCU.terminate();
    toSCP.terminate();
    thread.join();
}





///////////////////////////////////////////////////////////
//
// A SCP that responds to C-ECHO commands.
//
///////////////////////////////////////////////////////////
void echoScpThread(
        const std::string& name,
        PresentationContexts& presentationContexts,
        StreamReader& readSCP,
        StreamWriter& writeSCP)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        DimseService dimseService(scp);

        for(;;)
        {
            std::unique_ptr<CEchoCommand> command(dynamic_cast<CEchoCommand*>(dimseService.getCommand()));
            dimseService.sendCommandOrResponse(CEchoResponse(*command, dimseStatusCode_t::success));
        }
    }
    catch(const StreamClosedError&)
    {

    }
}


///////////////////////////////////////////////////////////
//
// ECHO SCU test
//
// This test requests a C-ECHO to a SCP, and wait for the
// C-ECHO responses.
//
///////////////////////////////////////////////////////////
TEST(dimseTest, echoSCUSCP)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.1.1");
    context.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    std::thread thread(
                imebra::tests::echoScpThread,
                std::ref(scpName),
                std::ref(presentationContexts),
                std::ref(readSCP),
                std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);
    DimseService dimse(scu);

    CEchoCommand echoCommand(
                "1.2.840.10008.1.1",
                dimse.getNextCommandID(),
                dimseCommandPriority_t::medium,
                "1.1.1.1.1");

    dimse.sendCommandOrResponse(echoCommand);

    std::unique_ptr<CEchoResponse> response(dimse.getCEchoResponse(echoCommand));
    EXPECT_EQ(dimseStatus_t::success, response->getStatus());
    EXPECT_EQ("1.1.1.1.1", response->getAffectedSopClassUid());

    toSCU.terminate();
    toSCP.terminate();

    thread.join();
}


///////////////////////////////////////////////////////////
//
// A SCP that wait for a cancelation of a C-MOVE command
//
///////////////////////////////////////////////////////////
void cancelScpThread(
        const std::string& name,
        PresentationContexts& presentationContexts,
        StreamReader& readSCP,
        StreamWriter& writeSCP)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        DimseService dimseService(scp);

        for(;;)
        {
            std::unique_ptr<CMoveCommand> command(dynamic_cast<CMoveCommand*>(dimseService.getCommand()));
            std::unique_ptr<CCancelCommand> cancel(dynamic_cast<CCancelCommand*>(dimseService.getCommand()));
            std::unique_ptr<CCancelCommand> cancel1(dynamic_cast<CCancelCommand*>(dimseService.getCommand()));

            if(cancel->getCancelMessageID() == command->getID())
            {
                dimseService.sendCommandOrResponse(CMoveResponse(*command, dimseStatusCode_t::canceled, 0, 0, 0, 0));
            }
            else
            {
                dimseService.sendCommandOrResponse(CMoveResponse(*command, dimseStatusCode_t::success, 0, 0, 0, 0));
            }
        }
    }
    catch(const StreamClosedError&)
    {

    }
}


///////////////////////////////////////////////////////////
//
// CANCEL SCU test
//
// This test requests a C-MOVE and then cancels it.
//
///////////////////////////////////////////////////////////
TEST(dimseTest, cancelSCUSCP)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.5.1.4.1.2.1.2");
    context.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    std::thread thread(
                imebra::tests::cancelScpThread,
                std::ref(scpName),
                std::ref(presentationContexts),
                std::ref(readSCP),
                std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);
    DimseService dimse(scu);

    DataSet keys(dimse.getTransferSyntax("1.2.840.10008.5.1.4.1.2.1.2"));
    keys.setString(TagId(tagId_t::QueryRetrieveLevel_0008_0052), "PATIENT");
    keys.setString(TagId(tagId_t::PatientID_0010_0020), "100");
    CMoveCommand moveCommand(
                "1.2.840.10008.5.1.4.1.2.1.2",
                dimse.getNextCommandID(),
                dimseCommandPriority_t::medium,
                "1.1.1.1.1",
                "Destination",
                keys);
    dimse.sendCommandOrResponse(moveCommand);

    CCancelCommand cancel("1.2.840.10008.5.1.4.1.2.1.2", dimse.getNextCommandID(), dimseCommandPriority_t::medium, moveCommand.getID());
    dimse.sendCommandOrResponse(cancel);
    CCancelCommand cancel1("1.2.840.10008.5.1.4.1.2.1.2", dimse.getNextCommandID(), dimseCommandPriority_t::medium, moveCommand.getID());
    dimse.sendCommandOrResponse(cancel1);

    std::this_thread::sleep_for(std::chrono::seconds(5));

    std::unique_ptr<CMoveResponse> response(dimse.getCMoveResponse(moveCommand));

    EXPECT_EQ(dimseStatus_t::cancel, response->getStatus());

    EXPECT_NO_THROW(dimse.sendCommandOrResponse(cancel));

    toSCU.terminate();
    toSCP.terminate();

    thread.join();
}


///////////////////////////////////////////////////////////
//
// A SCP that wait for a N-EVENT-REPORT command
//
///////////////////////////////////////////////////////////
void neventReportScpThread(
        const std::string& name,
        PresentationContexts& presentationContexts,
        StreamReader& readSCP,
        StreamWriter& writeSCP)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        DimseService dimseService(scp);

        for(;;)
        {
            std::unique_ptr<NEventReportCommand> command(dynamic_cast<NEventReportCommand*>(dimseService.getCommand()));

            DataSet eventReply(dimseService.getTransferSyntax(command->getAbstractSyntax()));
            std::unique_ptr<DataSet> pEventData(command->getPayloadDataSet());
            eventReply.setString(TagId(tagId_t::PatientName_0010_0010),
                                 pEventData->getString(TagId(tagId_t::PatientName_0010_0010), 0));
            dimseService.sendCommandOrResponse(NEventReportResponse(*command, eventReply));
        }
    }
    catch(const StreamClosedError&)
    {

    }
}


///////////////////////////////////////////////////////////
//
// N-EVENT-REPORT SCU test
//
// This test requests a N-EVENT-REPORT
//
///////////////////////////////////////////////////////////
TEST(dimseTest, neventReportSCUSCP)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.5.1.4.34.6.4");
    context.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    std::thread thread(
                imebra::tests::neventReportScpThread,
                std::ref(scpName),
                std::ref(presentationContexts),
                std::ref(readSCP),
                std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);
    DimseService dimse(scu);

    DataSet nevent(dimse.getTransferSyntax("1.2.840.10008.5.1.4.34.6.4"));
    nevent.setString(TagId(tagId_t::PatientName_0010_0010), "EVENT^PATIENT");
    NEventReportCommand eventCommand(
                "1.2.840.10008.5.1.4.34.6.4",
                dimse.getNextCommandID(),
                "1.1.1.1.1",
                "1.1.1.1.1.1.1",
                1,
                nevent);
    dimse.sendCommandOrResponse(eventCommand);

    std::unique_ptr<NEventReportResponse> pResponse(dimse.getNEventReportResponse(eventCommand));
    std::unique_ptr<DataSet> pEventInformation(pResponse->getPayloadDataSet());

    EXPECT_EQ("EVENT^PATIENT", pEventInformation->getString(TagId(tagId_t::PatientName_0010_0010), 0));
    EXPECT_EQ(1, pResponse->getEventID());

    toSCU.terminate();
    toSCP.terminate();

    thread.join();
}


///////////////////////////////////////////////////////////
//
// A SCP that wait for a N-GET command
//
///////////////////////////////////////////////////////////
void ngetScpThread(
        const std::string& name,
        PresentationContexts& presentationContexts,
        StreamReader& readSCP,
        StreamWriter& writeSCP)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        DimseService dimseService(scp);

        for(;;)
        {
            std::unique_ptr<NGetCommand> command(dynamic_cast<NGetCommand*>(dimseService.getCommand()));
            DataSet getReply(dimseService.getTransferSyntax(command->getAbstractSyntax()));

            attributeIdentifierList_t identifierList(command->getAttributeList());
            if(identifierList.size() == 2 &&
                    identifierList[0] == tagId_t::PatientName_0010_0010 &&
                    identifierList[1] == tagId_t::PatientID_0010_0020)
            {
                getReply.setString(TagId(tagId_t::PatientName_0010_0010), "GET^PATIENT");
                getReply.setString(TagId(tagId_t::PatientID_0010_0020), "100");
            }
            dimseService.sendCommandOrResponse(NGetResponse(*command, dimseStatusCode_t::success, getReply));
        }
    }
    catch(const StreamClosedError&)
    {

    }
}


///////////////////////////////////////////////////////////
//
// N-GET SCU test
//
// This test requests a N-GET to a SCP
//
///////////////////////////////////////////////////////////
TEST(dimseTest, ngetSCUSCP)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.5.1.4.34.6.4");
    context.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    std::thread thread(
                imebra::tests::ngetScpThread,
                std::ref(scpName),
                std::ref(presentationContexts),
                std::ref(readSCP),
                std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);
    DimseService dimse(scu);

    attributeIdentifierList_t identifierList;
    identifierList.push_back(tagId_t::PatientName_0010_0010);
    identifierList.push_back(tagId_t::PatientID_0010_0020);
    NGetCommand getCommand(
                "1.2.840.10008.5.1.4.34.6.4",
                dimse.getNextCommandID(),
                "1.1.1.1.1",
                "1.1.1.1.1.1.1",
                identifierList);
    dimse.sendCommandOrResponse(getCommand);

    std::unique_ptr<NGetResponse> pResponse(dimse.getNGetResponse(getCommand));
    std::unique_ptr<DataSet> pGetIdentifier(pResponse->getPayloadDataSet());

    EXPECT_EQ("GET^PATIENT", pGetIdentifier->getString(TagId(tagId_t::PatientName_0010_0010), 0));
    EXPECT_EQ("100", pGetIdentifier->getString(TagId(tagId_t::PatientID_0010_0020), 0));

    toSCU.terminate();
    toSCP.terminate();

    thread.join();
}




///////////////////////////////////////////////////////////
//
// A SCP that wait for a N-SET command
//
///////////////////////////////////////////////////////////
void nsetScpThread(
        const std::string& name,
        PresentationContexts& presentationContexts,
        StreamReader& readSCP,
        StreamWriter& writeSCP)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        DimseService dimseService(scp);

        for(;;)
        {
            std::unique_ptr<NSetCommand> command(dynamic_cast<NSetCommand*>(dimseService.getCommand()));
            std::unique_ptr<DataSet> pSetDataSet(command->getPayloadDataSet());

            attributeIdentifierList_t identifierList;

            if(pSetDataSet->getString(TagId(tagId_t::PatientName_0010_0010), 0) == "SET^PATIENT")
            {
                identifierList.push_back(tagId_t::PatientName_0010_0010);
                dimseService.sendCommandOrResponse(NSetResponse(*command, identifierList));
            }
            else
            {
                dimseService.sendCommandOrResponse(NSetResponse(*command, dimseStatusCode_t::unableToProcess));
            }
        }
    }
    catch(const StreamClosedError&)
    {

    }
}


///////////////////////////////////////////////////////////
//
// N-SET SCU test
//
// This test requests a N-SET to a SCP
//
///////////////////////////////////////////////////////////
TEST(dimseTest, nsetSCUSCP)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.5.1.4.34.6.4");
    context.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    std::thread thread(
                imebra::tests::nsetScpThread,
                std::ref(scpName),
                std::ref(presentationContexts),
                std::ref(readSCP),
                std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);
    DimseService dimse(scu);

    DataSet setDataset(dimse.getTransferSyntax("1.2.840.10008.5.1.4.34.6.4"));
    setDataset.setString(TagId(tagId_t::PatientName_0010_0010), "SET^PATIENT");

    NSetCommand setCommand(
                "1.2.840.10008.5.1.4.34.6.4",
                dimse.getNextCommandID(),
                "1.1.1.1.1",
                "1.1.1.1.1.1.1",
                setDataset);
    dimse.sendCommandOrResponse(setCommand);

    std::unique_ptr<NSetResponse> pResponse(dimse.getNSetResponse(setCommand));

    attributeIdentifierList_t identifier(pResponse->getModifiedAttributes());

    ASSERT_EQ(1u, identifier.size());
    EXPECT_EQ(tagId_t::PatientName_0010_0010, identifier[0]);

    toSCU.terminate();
    toSCP.terminate();

    thread.join();
}



///////////////////////////////////////////////////////////
//
// A SCP that wait for a N-ACTION command
//
///////////////////////////////////////////////////////////
void nActionScpThread(
        const std::string& name,
        PresentationContexts& presentationContexts,
        StreamReader& readSCP,
        StreamWriter& writeSCP)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        DimseService dimseService(scp);

        for(;;)
        {
            std::unique_ptr<NActionCommand> command(dynamic_cast<NActionCommand*>(dimseService.getCommand()));
            std::unique_ptr<DataSet> pSetDataSet(command->getPayloadDataSet());

            if(pSetDataSet->getString(TagId(tagId_t::PatientName_0010_0010), 0) == "ACTION^PATIENT")
            {
                dimseService.sendCommandOrResponse(NActionResponse(*command, *pSetDataSet));
            }
            else
            {
                dimseService.sendCommandOrResponse(NActionResponse(*command, dimseStatusCode_t::unableToProcess));
            }
        }
    }
    catch(const StreamClosedError&)
    {

    }
}


///////////////////////////////////////////////////////////
//
// N-ACTION SCU test
//
// This test requests a N-ACTION to a SCP
//
///////////////////////////////////////////////////////////
TEST(dimseTest, nActionSCUSCP)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.5.1.4.34.6.4");
    context.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    std::thread thread(
                imebra::tests::nActionScpThread,
                std::ref(scpName),
                std::ref(presentationContexts),
                std::ref(readSCP),
                std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);
    DimseService dimse(scu);

    DataSet actionDataset(dimse.getTransferSyntax("1.2.840.10008.5.1.4.34.6.4"));
    actionDataset.setString(TagId(tagId_t::PatientName_0010_0010), "ACTION^PATIENT");

    std::uint16_t actionID(101);

    NActionCommand actionCommand(
                "1.2.840.10008.5.1.4.34.6.4",
                dimse.getNextCommandID(),
                "1.1.1.1.1",
                "1.1.1.1.1.1.1",
                actionID,
                actionDataset);
    dimse.sendCommandOrResponse(actionCommand);

    std::unique_ptr<NActionResponse> pResponse(dimse.getNActionResponse(actionCommand));
    ASSERT_EQ((std::uint16_t)dimseStatusCode_t::success, pResponse->getStatusCode());
    ASSERT_EQ(actionID, pResponse->getActionID());

    std::unique_ptr<DataSet> pResponseDataSet(pResponse->getPayloadDataSet());
    EXPECT_EQ("ACTION^PATIENT", pResponseDataSet->getString(TagId(tagId_t::PatientName_0010_0010), 0));

    toSCU.terminate();
    toSCP.terminate();

    thread.join();
}



///////////////////////////////////////////////////////////
//
// A SCP that wait for a N-CREATE command
//
///////////////////////////////////////////////////////////
void nCreateScpThread(
        const std::string& name,
        PresentationContexts& presentationContexts,
        StreamReader& readSCP,
        StreamWriter& writeSCP)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        DimseService dimseService(scp);

        for(;;)
        {
            std::unique_ptr<NCreateCommand> command(dynamic_cast<NCreateCommand*>(dimseService.getCommand()));
            std::unique_ptr<DataSet> pCreateDataSet(command->getPayloadDataSet());

            if(pCreateDataSet->getString(TagId(tagId_t::PatientName_0010_0010), 0) == "CREATE^PATIENT")
            {
                dimseService.sendCommandOrResponse(NCreateResponse(*command, *pCreateDataSet));
            }
            else
            {
                dimseService.sendCommandOrResponse(NCreateResponse(*command, dimseStatusCode_t::outOfResources));
            }
        }
    }
    catch(const StreamClosedError&)
    {

    }
}


///////////////////////////////////////////////////////////
//
// N-CREATE SCU test
//
// This test requests a N-CREATE to a SCP
//
///////////////////////////////////////////////////////////
TEST(dimseTest, nCreateSCUSCP)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.5.1.4.34.6.4");
    context.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    std::thread thread(
                imebra::tests::nCreateScpThread,
                std::ref(scpName),
                std::ref(presentationContexts),
                std::ref(readSCP),
                std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);
    DimseService dimse(scu);

    DataSet createDataset(dimse.getTransferSyntax("1.2.840.10008.5.1.4.34.6.4"));
    createDataset.setString(TagId(tagId_t::PatientName_0010_0010), "CREATE^PATIENT");

    NCreateCommand createCommand(
                "1.2.840.10008.5.1.4.34.6.4",
                dimse.getNextCommandID(),
                "1.1.1.1.1",
                "1.1.1.1.1.1.1",
                createDataset);
    dimse.sendCommandOrResponse(createCommand);

    std::unique_ptr<NCreateResponse> pResponse(dimse.getNCreateResponse(createCommand));
    ASSERT_EQ((std::uint16_t)dimseStatusCode_t::success, pResponse->getStatusCode());

    std::unique_ptr<DataSet> pResponseDataSet(pResponse->getPayloadDataSet());
    EXPECT_EQ("CREATE^PATIENT", pResponseDataSet->getString(TagId(tagId_t::PatientName_0010_0010), 0));

    toSCU.terminate();
    toSCP.terminate();

    thread.join();
}



///////////////////////////////////////////////////////////
//
// A SCP that wait for a N-ACTION command
//
///////////////////////////////////////////////////////////
void nDeleteScpThread(
        const std::string& name,
        PresentationContexts& presentationContexts,
        StreamReader& readSCP,
        StreamWriter& writeSCP)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        DimseService dimseService(scp);

        for(;;)
        {
            std::unique_ptr<NDeleteCommand> command(dynamic_cast<NDeleteCommand*>(dimseService.getCommand()));
            dimseService.sendCommandOrResponse(NDeleteResponse(*command, dimseStatusCode_t::success));
        }
    }
    catch(const StreamClosedError&)
    {

    }
}


///////////////////////////////////////////////////////////
//
// N-ACTION SCU test
//
// This test requests a N-ACTION to a SCP
//
///////////////////////////////////////////////////////////
TEST(dimseTest, nDeleteSCUSCP)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.5.1.4.34.6.4");
    context.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    std::thread thread(
                imebra::tests::nDeleteScpThread,
                std::ref(scpName),
                std::ref(presentationContexts),
                std::ref(readSCP),
                std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);
    DimseService dimse(scu);

    NDeleteCommand deleteCommand(
                "1.2.840.10008.5.1.4.34.6.4",
                dimse.getNextCommandID(),
                "1.1.1.1.1",
                "1.1.1.1.1.1.1");
    dimse.sendCommandOrResponse(deleteCommand);

    std::unique_ptr<NDeleteResponse> pResponse(dimse.getNDeleteResponse(deleteCommand));
    ASSERT_EQ("1.1.1.1.1.1.1", pResponse->getAffectedSopInstanceUid());

    toSCU.terminate();
    toSCP.terminate();

    thread.join();
}


///////////////////////////////////////////////////////////
//
// A DIMSE SCP that will timeout after 10 seconds
//
///////////////////////////////////////////////////////////
void timeoutScpThread(
        const std::string& name,
        PresentationContexts& presentationContexts,
        StreamReader& readSCP,
        StreamWriter& writeSCP)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 10, 10);

        DimseService dimseService(scp);

        for(;;)
        {
            dimseService.getCommand();
        }
    }
    catch(const StreamClosedError&)
    {

    }
}


TEST(dimseTest, dimseTimeoutTest)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.5.1.4.34.6.4");
    context.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    std::thread thread(
                imebra::tests::timeoutScpThread,
                std::ref(scpName),
                std::ref(presentationContexts),
                std::ref(readSCP),
                std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);

    try
    {
        scu.getCommand();
        EXPECT_TRUE(false);
    }
    catch(const StreamClosedError& e)
    {

    }

    thread.join();

}








#ifndef DISABLE_DIMSE_INTEROPERABILITY_TEST

///////////////////////////////////////////////////////////
//
// Get all the files in a folder
//
///////////////////////////////////////////////////////////
std::list<std::string> getFilesInDirectory(const std::string &directory)
{
    std::list<std::string> files;

    DIR* dir(opendir(directory.c_str()));
    for(dirent* ent(readdir(dir)); ent != NULL; ent = readdir(dir))
    {
        const std::string fileName(ent->d_name);
        if(fileName[0] == '.')
        {
            continue;
        }
        const std::string fullFileName(directory + "/" + fileName);

        struct stat st;
        if (stat(fullFileName.c_str(), &st) == -1)
        {
            continue;
        }

        if((st.st_mode & S_IFDIR) == 0)
        {
            files.push_back(fullFileName);
        }
    }
    closedir(dir);

    return files;
}



//
// Store SCU interoperability test
//
// This test sends a DataSet to a DCMTK STORE SCP
// and check that the sent payload was received correctly.
//
///////////////////////////////////////////////////////////
TEST(dimseTest, storeSCUInteroperabilityTest)
{
    char* tempDirName = ::tempnam(0, "imebra");
    std::string dirName(tempDirName);
    free(tempDirName);

    mkdir(dirName.c_str(), 0700);

    pid_t pID = fork();
    if (pID == 0)                // child
    {
        execlp("storescp", "storescp", "-od", dirName.c_str(), "30003", 0);
    }
    else if (pID < 0)            // failed to fork
    {
        ASSERT_TRUE(false);
    }

    try
    {
        std::this_thread::sleep_for(std::chrono::seconds(5));

        TCPStream tcpStream(TCPActiveAddress("127.0.0.1", "30003"));

        StreamReader readSCU(tcpStream);
        StreamWriter writeSCU(tcpStream);

        std::string transferSyntax("1.2.840.10008.1.2.1");

        // Presentation context with a valid transfer syntax and an invalid one
        PresentationContext context("1.2.840.10008.1.1");
        context.addTransferSyntax("1"); // dummy transfer syntax
        context.addTransferSyntax(transferSyntax); // implicit VR little endian

        // Presentation context with dummy abstract syntax and valid transfer syntax
        PresentationContext dummy("1"); // dummy abstract syntax
        dummy.addTransferSyntax(transferSyntax); // implicit VR little endian

        // Presentation context with all dummy transfer syntaxes
        PresentationContext dummySyntaxes("1.2.840.10008.5.1.1.27");
        dummySyntaxes.addTransferSyntax("1"); // dummy transfer syntax
        dummySyntaxes.addTransferSyntax("2"); // dummy transfer syntax

        PresentationContexts presentationContexts;
        presentationContexts.addPresentationContext(context);
        presentationContexts.addPresentationContext(dummy);
        presentationContexts.addPresentationContext(dummySyntaxes);

        AssociationSCU scu("SCU", "SCP", 1, 1, presentationContexts, readSCU, writeSCU, 0);

        EXPECT_EQ(transferSyntax, scu.getTransferSyntax("1.2.840.10008.1.1"));
        EXPECT_THROW(scu.getTransferSyntax("1"), AcseNoTransferSyntaxError);
        EXPECT_THROW(scu.getTransferSyntax("1.2.840.10008.5.1.1.27"), AcseNoTransferSyntaxError);

        DimseService dimse(scu);

        DataSet payload(transferSyntax);
        payload.setString(TagId(tagId_t::SOPInstanceUID_0008_0018), "1.1.1.1");
        payload.setString(TagId(tagId_t::SOPClassUID_0008_0016), "1.1.1.1");
        payload.setString(TagId(tagId_t::PatientName_0010_0010),"Patient^Test");
        CStoreCommand command(
                    "1.2.840.10008.1.1",
                    dimse.getNextCommandID(),
                    dimseCommandPriority_t::medium,
                    payload.getString(TagId(tagId_t::SOPClassUID_0008_0016), 0),
                    payload.getString(TagId(tagId_t::SOPInstanceUID_0008_0018), 0),
                    "",
                    0,
                    payload);
        dimse.sendCommandOrResponse(command);
        std::unique_ptr<DimseResponse> response(dimse.getCStoreResponse(command));

        ASSERT_EQ(response->getStatus(), dimseStatus_t::success);

        std::list<std::string> files(getFilesInDirectory(dirName));

        ASSERT_EQ(files.size(), 1u);

        std::unique_ptr<DataSet> readDataSet(CodecFactory::load(files.front()));

        ASSERT_EQ(readDataSet->getString(TagId(tagId_t::PatientName_0010_0010), 0), "Patient^Test");
    }
    catch(...)
    {
        kill(pID, SIGTERM);
        throw;
    }

    kill(pID, SIGTERM);
}


///////////////////////////////////////////////////////////
//
// Executes a DCMTK Store SCU command
//
///////////////////////////////////////////////////////////
void storeScuThread(std::string transferSyntax, std::string sopClassUid, std::string sopInstanceUid)
{
    std::this_thread::sleep_for(std::chrono::seconds(5));

    char* tempFileName = ::tempnam(0, "dcmimebra");
    std::string fileName(tempFileName);
    free(tempFileName);

    DataSet dataSet(transferSyntax);
    dataSet.setString(TagId(tagId_t::SOPClassUID_0008_0016), sopClassUid);
    dataSet.setString(TagId(tagId_t::SOPInstanceUID_0008_0018), sopInstanceUid);
    dataSet.setString(TagId(tagId_t::PatientName_0010_0010), "Test^Patient");
    CodecFactory::save(dataSet, fileName, codecType_t::dicom);

    std::string command("storescu -v -aet scu -aec SCP 127.0.0.1 30004 ");
    command += fileName;

    system(command.c_str());
}


TEST(dimseTest, storeSCPInteroperabilityTest)
{

    std::string transferSyntax("1.2.840.10008.1.2.1");
    std::string sopClassUid("1.2.840.10008.5.1.4.1.1.1");
    std::string sopInstanceUid("1.1.1.1.1.1");
    std::thread thread(
                imebra::tests::storeScuThread,
                transferSyntax,
                sopClassUid,
                sopInstanceUid);

    TCPListener tcpListener(TCPPassiveAddress("", "30004"));
    std::unique_ptr<TCPStream> tcpStream(tcpListener.waitForConnection());

    StreamReader readSCU(*tcpStream);
    StreamWriter writeSCU(*tcpStream);

    PresentationContext context(sopClassUid);
    context.addTransferSyntax(transferSyntax);
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    AssociationSCP scp("SCP", 1, 1, presentationContexts, readSCU, writeSCU, 0, 10);

    DimseService dimse(scp);

    std::unique_ptr<CStoreCommand> command(dynamic_cast<CStoreCommand*>(dimse.getCommand()));
    std::unique_ptr<DataSet> pPayload(command->getPayloadDataSet());

    ASSERT_EQ("Test^Patient", pPayload->getString(TagId(tagId_t::PatientName_0010_0010), 0));

    dimse.sendCommandOrResponse(CStoreResponse(*command, dimseStatusCode_t::success));

    std::this_thread::sleep_for(std::chrono::seconds(5));

    thread.join();

}


void moveScuThread()
{
    std::this_thread::sleep_for(std::chrono::seconds(5));
    std::string command("movescu -v -k 0010,0020=\"100\" -P -aet scu -aec SCP -aem SCP1 127.0.0.1 30005");
    system(command.c_str());
}


//
// Move SCU interoperability test
//
// This executes the DCMTK command movescu and check that
// it is interpreted correctly by Imebra
//
///////////////////////////////////////////////////////////
TEST(dimseTest, moveSCPInteroperabilityTest)
{
    std::thread thread(
                imebra::tests::moveScuThread);

    {
        TCPListener tcpListener(TCPPassiveAddress("", "30005"));
        std::unique_ptr<TCPStream> tcpStream(tcpListener.waitForConnection());

        StreamReader readSCP(*tcpStream);
        StreamWriter writeSCP(*tcpStream);

        PresentationContext context("1.2.840.10008.5.1.4.1.2.1.2");
        context.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
        PresentationContexts presentationContexts;
        presentationContexts.addPresentationContext(context);

        AssociationSCP scp("SCP", 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);
        DimseService dimse(scp);

        std::unique_ptr<CMoveCommand> pMove(dynamic_cast<CMoveCommand*>(dimse.getCommand()));

        EXPECT_EQ("SCP1", pMove->getDestinationAET());

        std::unique_ptr<DataSet> pIdentifier(pMove->getPayloadDataSet());

        EXPECT_EQ("100", pIdentifier->getString(TagId(tagId_t::PatientID_0010_0020), 0));

        dimse.sendCommandOrResponse(CMoveResponse(*pMove, dimseStatusCode_t::pending, 1, 0, 0, 0));
        dimse.sendCommandOrResponse(CMoveResponse(*pMove, dimseStatusCode_t::success, 0, 1, 0, 0));

        std::this_thread::sleep_for(std::chrono::seconds(5));
    }
    thread.join();
}


//
// Executes a command and returns its output
//
///////////////////////////////////////////////////////////
std::string execute(const char* cmd)
{
    std::array<char, 128> buffer;
    std::string result;
    std::shared_ptr<FILE> pipe(popen(cmd, "r"), pclose);
    if (!pipe) throw std::runtime_error("popen() failed!");
    while (!feof(pipe.get()))
    {
        if(fgets(buffer.data(), 128, pipe.get()) != nullptr)
        {
            result += buffer.data();
        }
    }
    return result;
}


void findScuThread(std::string* pResponse)
{
    std::this_thread::sleep_for(std::chrono::seconds(5));
    std::string command("findscu -v -k 0010,0020=\"100\" -P -aet scu -aec SCP 127.0.0.1 30005 2>&1");
    *pResponse = execute(command.c_str());
}


//
// Find SCU interoperability test
//
// This executes the DCMTK command findscu and check that
// it is interpreted correctly by Imebra
//
///////////////////////////////////////////////////////////
TEST(dimseTest, findSCPInteroperabilityTest)
{
    std::string responseString;
    std::thread thread(imebra::tests::findScuThread, &responseString);

    {
        TCPListener tcpListener(TCPPassiveAddress("", "30005"));
        std::unique_ptr<TCPStream> tcpStream(tcpListener.waitForConnection());

        StreamReader readSCP(*tcpStream);
        StreamWriter writeSCP(*tcpStream);

        PresentationContext context("1.2.840.10008.5.1.4.1.2.1.1");
        context.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
        PresentationContexts presentationContexts;
        presentationContexts.addPresentationContext(context);

        AssociationSCP scp("SCP", 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);
        DimseService dimse(scp);

        std::unique_ptr<CFindCommand> pFind(dynamic_cast<CFindCommand*>(dimse.getCommand()));

        std::unique_ptr<DataSet> pIdentifier(pFind->getPayloadDataSet());

        EXPECT_EQ("100", pIdentifier->getString(TagId(tagId_t::PatientID_0010_0020), 0));

        DataSet study0(dimse.getTransferSyntax(pFind->getAbstractSyntax()));
        study0.setString(TagId(tagId_t::PatientID_0010_0020), "100");
        study0.setString(TagId(tagId_t::StudyID_0020_0010), "110");
        dimse.sendCommandOrResponse(CFindResponse(*pFind, study0));

        DataSet study1(dimse.getTransferSyntax(pFind->getAbstractSyntax()));
        study1.setString(TagId(tagId_t::PatientID_0010_0020), "100");
        study1.setString(TagId(tagId_t::StudyID_0020_0010), "120");
        dimse.sendCommandOrResponse(CFindResponse(*pFind, study1));

        dimse.sendCommandOrResponse(CFindResponse(*pFind, dimseStatusCode_t::success));

        std::this_thread::sleep_for(std::chrono::seconds(5));
    }
    thread.join();

    EXPECT_NE(std::string::npos, responseString.find("110"));
    EXPECT_NE(std::string::npos, responseString.find("120"));
}


#endif // DISABLE_DIMSE_INTEROPERABILITY_TEST



} // namespace tests

} // namespace imebra
