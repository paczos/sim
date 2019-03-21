#include <imebra/imebra.h>
#include <gtest/gtest.h>
#include <thread>
#include <memory>
#include <vector>

namespace imebra
{

namespace tests
{

void scpThread(const std::string& name, PresentationContexts& presentationContexts, StreamReader& readSCP, StreamWriter& writeSCP)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        for(;;)
        {
            std::unique_ptr<AssociationMessage> pCommand(scp.getCommand());

            // First send a response with a wrong ID: it should throw
            {
                DataSet responseDataSet;
                responseDataSet.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x8001, tagVR_t::US);
                responseDataSet.setUnsignedLong(TagId(tagId_t::MessageIDBeingRespondedTo_0000_0120), 0xffff, tagVR_t::US);
                responseDataSet.setString(TagId(tagId_t::SeriesInstanceUID_0020_000E), "1.2.3.4.5");
                responseDataSet.setUnsignedLong(TagId(tagId_t::Status_0000_0900), 0x0000);
                AssociationMessage response(pCommand->getAbstractSyntax());
                response.addDataSet(responseDataSet);
                EXPECT_THROW(scp.sendMessage(response), AcseWrongResponseIdError);
            }

            // Now send the real response
            {
                std::unique_ptr<DataSet> responseDataSet(pCommand->getCommand());
                responseDataSet->setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x8001, tagVR_t::US);
                std::uint32_t messageId(responseDataSet->getUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0));
                responseDataSet->setUnsignedLong(TagId(tagId_t::MessageIDBeingRespondedTo_0000_0120), messageId, tagVR_t::US);
                responseDataSet->setString(TagId(tagId_t::SeriesInstanceUID_0020_000E), "1.2.3.4.5");
                responseDataSet->setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), pCommand->hasPayload() ? 0 : 0x0101);
                responseDataSet->setUnsignedLong(TagId(tagId_t::Status_0000_0900), 0x0000);

                AssociationMessage response(pCommand->getAbstractSyntax());
                response.addDataSet(*responseDataSet);

                if(pCommand->hasPayload())
                {
                    std::unique_ptr<DataSet> payload(pCommand->getPayload());
                    response.addDataSet(*payload);
                }

                scp.sendMessage(response);

            }
        }
    }
    catch(const StreamClosedError&)
    {

    }
}


void scpThreadMultipleOperations(const std::string& name, PresentationContexts& presentationContexts, StreamReader& readSCP, StreamWriter& writeSCP, std::uint32_t maxPerformed)
{
    try
    {
        AssociationSCP scp(name, 1, maxPerformed, presentationContexts, readSCP, writeSCP, 0, 10);

        for(;;)
        {
            std::unique_ptr<AssociationMessage> pCommand(scp.getCommand());

            // Now send the real response
            {
                std::unique_ptr<DataSet> responseDataSet(pCommand->getCommand());
                responseDataSet->setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x8001, tagVR_t::US);
                std::uint32_t messageId(responseDataSet->getUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0));
                responseDataSet->setUnsignedLong(TagId(tagId_t::MessageIDBeingRespondedTo_0000_0120), messageId, tagVR_t::US);
                responseDataSet->setString(TagId(tagId_t::SeriesInstanceUID_0020_000E), "1.2.3.4.5");
                responseDataSet->setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), pCommand->hasPayload() ? 0 : 0x0101);
                responseDataSet->setUnsignedLong(TagId(tagId_t::Status_0000_0900), 0x0000);

                AssociationMessage response(pCommand->getAbstractSyntax());
                response.addDataSet(*responseDataSet);

                if(pCommand->hasPayload())
                {
                    std::unique_ptr<DataSet> payload(pCommand->getPayload());
                    response.addDataSet(*payload);
                }

                scp.sendMessage(response);
            }
        }
    }
    catch(const StreamClosedError&)
    {

    }
}


void scpThreadRejectCalledAET(const std::string& name, PresentationContexts& presentationContexts, StreamReader& readSCP, StreamWriter& writeSCP)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        for(;;)
        {
            std::unique_ptr<AssociationMessage> pCommand(scp.getCommand());

        }
    }
    catch(const AcseSCUCalledAETNotRecognizedError&)
    {
    }
}


void scpThreadDontAnswer(const std::string& name, PresentationContexts& presentationContexts, StreamReader& readSCP, StreamWriter& writeSCP)
{
    try
    {
        AssociationSCP scp(name, 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);

        for(;;)
        {
            std::unique_ptr<AssociationMessage> pCommand(scp.getCommand());
        }
    }
    catch(const StreamClosedError&)
    {

    }
}



//
// Negotiate one transfer syntax
//
///////////////////////////////////////////////////////////
TEST(acseTest, negotiationOneTransferSyntax)
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

    std::thread scp(imebra::tests::scpThread, std::ref(scpName), std::ref(presentationContexts), std::ref(readSCP), std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);

    AssociationMessage command("1.2.840.10008.1.1");
    DataSet dataset0;
    dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
    dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
    dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4");
    dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);
    command.addDataSet(dataset0);
    scu.sendMessage(command);

    std::unique_ptr<AssociationMessage> pResponse(scu.getResponse(1));
    std::unique_ptr<DataSet> responseDataSet(pResponse->getCommand());
    EXPECT_EQ("1.2.3.4", responseDataSet->getString(TagId(tagId_t::StudyInstanceUID_0020_000D), 0));
    EXPECT_EQ("1.2.3.4.5", responseDataSet->getString(TagId(tagId_t::SeriesInstanceUID_0020_000E), 0));
    EXPECT_EQ("1.2.840.10008.1.2",responseDataSet->getString(TagId(tagId_t::TransferSyntaxUID_0002_0010), 0));

    scu.release();

    scp.join();
}


TEST(acseTest, scpScuRole)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.1.1", false, true);
    context.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    std::thread scp(imebra::tests::scpThread, std::ref(scpName), std::ref(presentationContexts), std::ref(readSCP), std::ref(writeSCP));

    {
        AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);

        AssociationMessage command("1.2.840.10008.1.1");
        DataSet dataset0;
        dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
        dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
        dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4");
        dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);

        command.addDataSet(dataset0);
        EXPECT_THROW(scu.sendMessage(command), AcseWrongRoleError);

        scu.release();
    }
    scp.join();
}


TEST(acseTest, negotiationMultipleTransferSyntaxes)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext context("1.2.840.10008.1.1");
    context.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    context.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(context);

    const std::string scpName("SCP");

    std::thread scp(imebra::tests::scpThread, std::ref(scpName), std::ref(presentationContexts), std::ref(readSCP), std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, presentationContexts, readSCU, writeSCU, 0);

    AssociationMessage command("1.2.840.10008.1.1");
    DataSet dataset0;
    dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
    dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
    dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4");
    dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);
    command.addDataSet(dataset0);
    scu.sendMessage(command);

    std::unique_ptr<AssociationMessage> pResponse(scu.getResponse(1));
    std::unique_ptr<DataSet> responseDataSet(pResponse->getCommand());
    EXPECT_EQ("1.2.3.4", responseDataSet->getString(TagId(tagId_t::StudyInstanceUID_0020_000D), 0));
    EXPECT_EQ("1.2.3.4.5", responseDataSet->getString(TagId(tagId_t::SeriesInstanceUID_0020_000E), 0));
    EXPECT_EQ("1.2.840.10008.1.2",responseDataSet->getString(TagId(tagId_t::TransferSyntaxUID_0002_0010), 0));

    scu.release();

    scp.join();
}


TEST(acseTest, negotiationPartialMatchTransferSyntaxes)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext scuContext0("1.2.840.10008.1.1");
    scuContext0.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    scuContext0.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian

    PresentationContext scuContext1("1.2.840.10008.1.1.1.1.1.1.1.1"); // This will be rejected
    scuContext1.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    scuContext1.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian

    PresentationContexts scuPresentationContexts;
    scuPresentationContexts.addPresentationContext(scuContext0);
    scuPresentationContexts.addPresentationContext(scuContext1);

    PresentationContext scpContext("1.2.840.10008.1.1");
    scpContext.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian

    PresentationContexts scpPresentationContexts;
    scpPresentationContexts.addPresentationContext(scpContext);

    const std::string scpName("SCP");

    std::thread scp(imebra::tests::scpThread, std::ref(scpName), std::ref(scpPresentationContexts), std::ref(readSCP), std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, scuPresentationContexts, readSCU, writeSCU, 0);

    EXPECT_EQ("1.2.840.10008.1.2.1", scu.getTransferSyntax("1.2.840.10008.1.1"));
    EXPECT_THROW(scu.getTransferSyntax("1.2.840.10008.1.1.1.1.1.1.1.1"), AcseNoTransferSyntaxError);
    EXPECT_THROW(scu.getTransferSyntax("1"), AcsePresentationContextNotRequestedError);

    AssociationMessage command("1.2.840.10008.1.1");
    DataSet dataset0;
    dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
    dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
    dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4");
    dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);

    command.addDataSet(dataset0);
    scu.sendMessage(command);

    std::unique_ptr<AssociationMessage> pResponse(scu.getResponse(1));
    std::unique_ptr<DataSet> responseDataSet(pResponse->getCommand());
    EXPECT_EQ("1.2.840.10008.1.1", pResponse->getAbstractSyntax());
    EXPECT_EQ("1.2.3.4", responseDataSet->getString(TagId(tagId_t::StudyInstanceUID_0020_000D), 0));
    EXPECT_EQ("1.2.3.4.5", responseDataSet->getString(TagId(tagId_t::SeriesInstanceUID_0020_000E), 0));
    EXPECT_EQ("1.2.840.10008.1.2.1",responseDataSet->getString(TagId(tagId_t::TransferSyntaxUID_0002_0010), 0));

    scu.release();

    scp.join();
}


TEST(acseTest, sendPayload)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext scuContext("1.2.840.10008.1.1");
    scuContext.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    scuContext.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContexts scuPresentationContexts;
    scuPresentationContexts.addPresentationContext(scuContext);

    PresentationContext scpContext("1.2.840.10008.1.1");
    scpContext.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContexts scpPresentationContexts;
    scpPresentationContexts.addPresentationContext(scpContext);

    const std::string scpName("SCP");

    const size_t maxPayloadSize(128000);

    std::thread scp(imebra::tests::scpThread, std::ref(scpName), std::ref(scpPresentationContexts), std::ref(readSCP), std::ref(writeSCP));

    {
        AssociationSCU scu("SCU", scpName, 1, 1, scuPresentationContexts, readSCU, writeSCU, 0);

        for(size_t payloadSize(1); payloadSize < maxPayloadSize; payloadSize += 128)
        {
            AssociationMessage command("1.2.840.10008.1.1");

            DataSet dataset0;
            dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
            dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
            dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0);

            command.addDataSet(dataset0);

            DataSet payload;
            {
                std::unique_ptr<WritingDataHandlerNumeric> writing(payload.getWritingDataHandlerRaw(TagId(tagId_t::PixelData_7FE0_0010), 0, tagVR_t::OB));
                writing->setSize(payloadSize);
                size_t dummy;
                char* payloadData(writing->data(&dummy));
                for(size_t fillPayload(0); fillPayload != payloadSize; ++fillPayload)
                {
                    payloadData[fillPayload] = (char)(fillPayload & 0x7f);
                }
            }
            command.addDataSet(payload);

            scu.sendMessage(command);

            std::unique_ptr<AssociationMessage> pResponse(scu.getResponse(1));
            std::unique_ptr<DataSet> responseCommand(pResponse->getCommand());
            std::unique_ptr<DataSet> responsePayload(pResponse->getPayload());

            EXPECT_EQ("1.2.840.10008.1.1", pResponse->getAbstractSyntax());
            {
                std::unique_ptr<ReadingDataHandlerNumeric> reading(responsePayload->getReadingDataHandlerRaw(TagId(tagId_t::PixelData_7FE0_0010), 0));
                size_t dummy;
                const char* payloadData(reading->data(&dummy));
                for(size_t fillPayload(0); fillPayload != payloadSize; ++fillPayload)
                {
                    EXPECT_EQ(payloadData[fillPayload], (char)(fillPayload & 0x7f));
                }
                EXPECT_EQ(reading->getSize(), (payloadSize + 1) & 0xfffffffe);
            }
        }

        scu.release();
    }

    scp.join();
}


void scuThread(AssociationSCU& scu, std::uint16_t firstMessageId, size_t numberOfMessages)
{
    const size_t payloadSize(100);

    for(std::uint16_t messageNumber(0); messageNumber != numberOfMessages; ++messageNumber)
    {
        AssociationMessage command("1.2.840.10008.1.1");

        DataSet dataset0;
        dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
        dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), (std::uint16_t)(firstMessageId + messageNumber), tagVR_t::US);
        dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0);

        command.addDataSet(dataset0);

        DataSet payload;
        {
            std::unique_ptr<WritingDataHandlerNumeric> writing(payload.getWritingDataHandlerRaw(TagId(tagId_t::PixelData_7FE0_0010), 0, tagVR_t::OB));
            writing->setSize(payloadSize);
            size_t dummy;
            char* payloadData(writing->data(&dummy));
            for(size_t fillPayload(0); fillPayload != payloadSize; ++fillPayload)
            {
                payloadData[fillPayload] = (char)((fillPayload + firstMessageId) & 0x7f);
            }
        }
        command.addDataSet(payload);

        scu.sendMessage(command);

        std::unique_ptr<AssociationMessage> pResponse(scu.getResponse((std::uint16_t)(firstMessageId + messageNumber)));
        std::unique_ptr<DataSet> responseCommand(pResponse->getCommand());
        std::unique_ptr<DataSet> responsePayload(pResponse->getPayload());

        EXPECT_EQ("1.2.840.10008.1.1", pResponse->getAbstractSyntax());
        {
            std::unique_ptr<ReadingDataHandlerNumeric> reading(responsePayload->getReadingDataHandlerRaw(TagId(tagId_t::PixelData_7FE0_0010), 0));
            size_t dummy;
            const char* payloadData(reading->data(&dummy));
            for(size_t fillPayload(0); fillPayload != payloadSize; ++fillPayload)
            {
                EXPECT_EQ(payloadData[fillPayload], (char)((fillPayload + firstMessageId) & 0x7f));
            }
            EXPECT_EQ(reading->getSize(), (payloadSize + 1) & 0xfffffffe);
        }
    }
}


TEST(acseTest, overlappingOperations)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext scuContext("1.2.840.10008.1.1");
    scuContext.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    scuContext.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContexts scuPresentationContexts;
    scuPresentationContexts.addPresentationContext(scuContext);

    PresentationContext scpContext("1.2.840.10008.1.1");
    scpContext.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContexts scpPresentationContexts;
    scpPresentationContexts.addPresentationContext(scpContext);

    const std::string scpName("SCP");

    const size_t maxInvoked(10);
    const size_t numMessages(1000);

    std::thread scp(imebra::tests::scpThreadMultipleOperations, std::ref(scpName), std::ref(scpPresentationContexts), std::ref(readSCP), std::ref(writeSCP), maxInvoked);

    {
        AssociationSCU scu("SCU", scpName, maxInvoked, 1, scuPresentationContexts, readSCU, writeSCU, 0);

        std::vector<std::shared_ptr<std::thread> > scuThreads;

        for(std::uint16_t launchThreads(0); launchThreads != maxInvoked; ++launchThreads)
        {
            scuThreads.push_back(std::make_shared<std::thread>(imebra::tests::scuThread, std::ref(scu), launchThreads * numMessages, numMessages));
        }

        for(size_t launchThreads(0); launchThreads != maxInvoked; ++launchThreads)
        {
            scuThreads[launchThreads]->join();
        }

        scu.release();
    }

    scp.join();
}


TEST(acseTest, negotiationMultiplePresentationContexts)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext scuContext0("1.2.840.10008.1.1");
    scuContext0.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    scuContext0.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContext scuContext1("1.2.840.10008.1.1.2");
    scuContext1.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    scuContext1.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian

    PresentationContexts scuPresentationContexts;
    scuPresentationContexts.addPresentationContext(scuContext0);
    scuPresentationContexts.addPresentationContext(scuContext1);

    PresentationContext scpContext0("1.2.840.10008.1.1");
    scpContext0.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContext scpContext1("1.2.840.10008.1.1.2");
    scpContext1.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian

    PresentationContexts scpPresentationContexts;
    scpPresentationContexts.addPresentationContext(scpContext0);
    scpPresentationContexts.addPresentationContext(scpContext1);

    const std::string scpName("SCP");

    std::thread scp(imebra::tests::scpThread, std::ref(scpName), std::ref(scpPresentationContexts), std::ref(readSCP), std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, scuPresentationContexts, readSCU, writeSCU, 0);

    {
        AssociationMessage command("1.2.840.10008.1.1");
        DataSet dataset0;
        dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
        dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
        dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4");
        dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);

        command.addDataSet(dataset0);
        scu.sendMessage(command);

        std::unique_ptr<AssociationMessage> pResponse(scu.getResponse(1));
        std::unique_ptr<DataSet> responseDataSet(pResponse->getCommand());
        EXPECT_EQ("1.2.840.10008.1.1", pResponse->getAbstractSyntax());
        EXPECT_EQ("1.2.3.4", responseDataSet->getString(TagId(tagId_t::StudyInstanceUID_0020_000D), 0));
        EXPECT_EQ("1.2.3.4.5", responseDataSet->getString(TagId(tagId_t::SeriesInstanceUID_0020_000E), 0));
        EXPECT_EQ("1.2.840.10008.1.2.1",responseDataSet->getString(TagId(tagId_t::TransferSyntaxUID_0002_0010), 0));
    }

    {
        AssociationMessage command("1.2.840.10008.1.1.2");
        DataSet dataset0;
        dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
        dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
        dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4");
        dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);

        command.addDataSet(dataset0);
        scu.sendMessage(command);

        std::unique_ptr<AssociationMessage> pResponse(scu.getResponse(1));
        std::unique_ptr<DataSet> responseDataSet(pResponse->getCommand());
        EXPECT_EQ("1.2.840.10008.1.1.2", pResponse->getAbstractSyntax());
        EXPECT_EQ("1.2.3.4", responseDataSet->getString(TagId(tagId_t::StudyInstanceUID_0020_000D), 0));
        EXPECT_EQ("1.2.3.4.5", responseDataSet->getString(TagId(tagId_t::SeriesInstanceUID_0020_000E), 0));
        EXPECT_EQ("1.2.840.10008.1.2",responseDataSet->getString(TagId(tagId_t::TransferSyntaxUID_0002_0010), 0));
    }

    scu.release();

    scp.join();
}


TEST(acseTest, negotiationNoTransferSyntax)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext scuContext0("1.2.840.10008.1.1");
    scuContext0.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    scuContext0.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContext scuContext1("1.2.840.10008.1.1.2");
    scuContext1.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian

    PresentationContexts scuPresentationContexts;
    scuPresentationContexts.addPresentationContext(scuContext0);
    scuPresentationContexts.addPresentationContext(scuContext1);

    PresentationContext scpContext0("1.2.840.10008.1.1");
    scpContext0.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContext scpContext1("1.2.840.10008.1.1.2");
    scpContext1.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian

    PresentationContexts scpPresentationContexts;
    scpPresentationContexts.addPresentationContext(scpContext0);
    scpPresentationContexts.addPresentationContext(scpContext1);

    const std::string scpName("SCP");

    std::thread scp(imebra::tests::scpThread, std::ref(scpName), std::ref(scpPresentationContexts), std::ref(readSCP), std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, scuPresentationContexts, readSCU, writeSCU, 0);

    {
        AssociationMessage command("1.2.840.10008.1.1");
        DataSet dataset0;
        dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
        dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
        dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4");
        dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);

        command.addDataSet(dataset0);
        scu.sendMessage(command);

        std::unique_ptr<AssociationMessage> pResponse(scu.getResponse(1));
        std::unique_ptr<DataSet> responseDataSet(pResponse->getCommand());
        EXPECT_EQ("1.2.840.10008.1.1", pResponse->getAbstractSyntax());
        EXPECT_EQ("1.2.3.4", responseDataSet->getString(TagId(tagId_t::StudyInstanceUID_0020_000D), 0));
        EXPECT_EQ("1.2.3.4.5", responseDataSet->getString(TagId(tagId_t::SeriesInstanceUID_0020_000E), 0));
        EXPECT_EQ("1.2.840.10008.1.2.1",responseDataSet->getString(TagId(tagId_t::TransferSyntaxUID_0002_0010), 0));
    }

    {
        // This should fail (no transfer syntax)
        AssociationMessage command("1.2.840.10008.1.1.2");
        DataSet dataset0;
        dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
        dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
        dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4");
        dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);
        command.addDataSet(dataset0);

        EXPECT_THROW(scu.sendMessage(command), AcseNoTransferSyntaxError);

    }

    {
        AssociationMessage command("1.2.840.10008.1.1");
        DataSet dataset0;
        dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
        dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
        dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4.7");
        dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);

        command.addDataSet(dataset0);
        scu.sendMessage(command);

        std::unique_ptr<AssociationMessage> pResponse(scu.getResponse(1));
        std::unique_ptr<DataSet> responseDataSet(pResponse->getCommand());
        EXPECT_EQ("1.2.840.10008.1.1", pResponse->getAbstractSyntax());
        EXPECT_EQ("1.2.3.4.7", responseDataSet->getString(TagId(tagId_t::StudyInstanceUID_0020_000D), 0));
        EXPECT_EQ("1.2.3.4.5", responseDataSet->getString(TagId(tagId_t::SeriesInstanceUID_0020_000E), 0));
        EXPECT_EQ("1.2.840.10008.1.2.1",responseDataSet->getString(TagId(tagId_t::TransferSyntaxUID_0002_0010), 0));
    }

    scu.release();

    scp.join();
}


TEST(acseTest, negotiationNoPresentationContext)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext scuContext0("1.2.840.10008.1.1");
    scuContext0.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    scuContext0.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContext scuContext1("1.2.840.10008.1.1.2");
    scuContext1.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian

    PresentationContexts scuPresentationContexts;
    scuPresentationContexts.addPresentationContext(scuContext0);
    scuPresentationContexts.addPresentationContext(scuContext1);

    PresentationContext scpContext0("1.2.840.10008.1.1");
    scpContext0.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian

    PresentationContexts scpPresentationContexts;
    scpPresentationContexts.addPresentationContext(scpContext0);

    const std::string scpName("SCP");

    std::thread scp(imebra::tests::scpThread, std::ref(scpName), std::ref(scpPresentationContexts), std::ref(readSCP), std::ref(writeSCP));

    AssociationSCU scu("SCU", scpName, 1, 1, scuPresentationContexts, readSCU, writeSCU, 0);

    {
        AssociationMessage command("1.2.840.10008.1.1");
        DataSet dataset0;
        dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
        dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
        dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4");
        dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);

        command.addDataSet(dataset0);
        scu.sendMessage(command);

        std::unique_ptr<AssociationMessage> pResponse(scu.getResponse(1));
        std::unique_ptr<DataSet> responseDataSet(pResponse->getCommand());
        EXPECT_EQ("1.2.840.10008.1.1", pResponse->getAbstractSyntax());
        EXPECT_EQ("1.2.3.4", responseDataSet->getString(TagId(tagId_t::StudyInstanceUID_0020_000D), 0));
        EXPECT_EQ("1.2.3.4.5", responseDataSet->getString(TagId(tagId_t::SeriesInstanceUID_0020_000E), 0));
        EXPECT_EQ("1.2.840.10008.1.2.1",responseDataSet->getString(TagId(tagId_t::TransferSyntaxUID_0002_0010), 0));
    }

    {
        // This should fail (no presentation context in scp)
        AssociationMessage command("1.2.840.10008.1.1.2");
        DataSet dataset0;
        dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
        dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
        dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4");
        dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);

        command.addDataSet(dataset0);
        EXPECT_THROW(scu.sendMessage(command), AcseNoTransferSyntaxError);

    }

    {
        // This should fail (no presentation context in scu)
        AssociationMessage command("1.2.840.10008.1.1.3");
        DataSet dataset0;
        dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
        dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
        dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4");
        dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);

        command.addDataSet(dataset0);
        EXPECT_THROW(scu.sendMessage(command), AcsePresentationContextNotRequestedError);

    }

    {
        AssociationMessage command("1.2.840.10008.1.1");
        DataSet dataset0;
        dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
        dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
        dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4.7");
        dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);

        command.addDataSet(dataset0);
        scu.sendMessage(command);

        std::unique_ptr<AssociationMessage> pResponse(scu.getResponse(1));
        std::unique_ptr<DataSet> responseDataSet(pResponse->getCommand());
        EXPECT_EQ("1.2.840.10008.1.1", pResponse->getAbstractSyntax());
        EXPECT_EQ("1.2.3.4.7", responseDataSet->getString(TagId(tagId_t::StudyInstanceUID_0020_000D), 0));
        EXPECT_EQ("1.2.3.4.5", responseDataSet->getString(TagId(tagId_t::SeriesInstanceUID_0020_000E), 0));
        EXPECT_EQ("1.2.840.10008.1.2.1",responseDataSet->getString(TagId(tagId_t::TransferSyntaxUID_0002_0010), 0));
    }

    scu.release();

    scp.join();
}

TEST(acseTest, rejectAssociationName)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext scuContext0("1.2.840.10008.1.1");
    scuContext0.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    scuContext0.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContext scuContext1("1.2.840.10008.1.1.2");
    scuContext1.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian

    PresentationContexts scuPresentationContexts;
    scuPresentationContexts.addPresentationContext(scuContext0);
    scuPresentationContexts.addPresentationContext(scuContext1);

    PresentationContext scpContext0("1.2.840.10008.1.1");
    scpContext0.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian

    PresentationContexts scpPresentationContexts;
    scpPresentationContexts.addPresentationContext(scpContext0);

    const std::string scpName("SCP");

    std::thread scp(imebra::tests::scpThreadRejectCalledAET, std::ref(scpName), std::ref(scpPresentationContexts), std::ref(readSCP), std::ref(writeSCP));

    EXPECT_THROW(AssociationSCU scu("SCU", scpName + "wrong", 1, 1, scuPresentationContexts, readSCU, writeSCU, 0), imebra::AcseSCUCalledAETNotRecognizedError);

    scp.join();
}


TEST(acseTest, invokeTooManyOperations)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCU(toSCU);
    StreamWriter writeSCU(toSCP);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext scuContext0("1.2.840.10008.1.1");
    scuContext0.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian
    scuContext0.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian
    PresentationContext scuContext1("1.2.840.10008.1.1.2");
    scuContext1.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian

    PresentationContexts scuPresentationContexts;
    scuPresentationContexts.addPresentationContext(scuContext0);
    scuPresentationContexts.addPresentationContext(scuContext1);

    PresentationContext scpContext0("1.2.840.10008.1.1");
    scpContext0.addTransferSyntax("1.2.840.10008.1.2.1"); // explicit VR little endian

    PresentationContexts scpPresentationContexts;
    scpPresentationContexts.addPresentationContext(scpContext0);

    const std::string scpName("SCP");

    std::thread scp(imebra::tests::scpThreadDontAnswer, std::ref(scpName), std::ref(scpPresentationContexts), std::ref(readSCP), std::ref(writeSCP));

    {
        AssociationSCU scu("SCU", scpName, 1, 1, scuPresentationContexts, readSCU, writeSCU, 0);

        {
            AssociationMessage command("1.2.840.10008.1.1");
            DataSet dataset0;
            dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
            dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
            dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4.7");
            dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);

            command.addDataSet(dataset0);
            scu.sendMessage(command);
        }

        {
            AssociationMessage command("1.2.840.10008.1.1");
            DataSet dataset0;
            dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
            dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x2, tagVR_t::US);
            dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4.7");
            dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);

            command.addDataSet(dataset0);
            EXPECT_THROW(scu.sendMessage(command), AcseTooManyOperationsInvokedError);
        }

        {
            AssociationMessage command("1.2.840.10008.1.1");
            DataSet dataset0;
            dataset0.setUnsignedLong(TagId(tagId_t::CommandField_0000_0100), 0x1, tagVR_t::US);
            dataset0.setUnsignedLong(TagId(tagId_t::MessageID_0000_0110), 0x1, tagVR_t::US);
            dataset0.setString(TagId(tagId_t::StudyInstanceUID_0020_000D), "1.2.3.4.7");
            dataset0.setUnsignedLong(TagId(tagId_t::CommandDataSetType_0000_0800), 0x101);

            command.addDataSet(dataset0);
            EXPECT_THROW(scu.sendMessage(command), AcseWrongCommandIdError);
        }

        scu.release();
    }

    scp.join();
}


TEST(acseTest, artimTest)
{
    Pipe toSCU(1024), toSCP(1024);

    StreamReader readSCP(toSCP);
    StreamWriter writeSCP(toSCU);

    PresentationContext scuContext("1.2.840.10008.1.1");
    scuContext.addTransferSyntax("1.2.840.10008.1.2"); // implicit VR little endian

    PresentationContexts presentationContexts;
    presentationContexts.addPresentationContext(scuContext);

    const std::string scpName("SCP");

    try
    {
        AssociationSCP scp("SCP", 1, 1, presentationContexts, readSCP, writeSCP, 0, 10);
        EXPECT_TRUE(false);
    }
    catch(const StreamClosedError&)
    {

    }

}


} // namespace tests

} // namespace imebra
