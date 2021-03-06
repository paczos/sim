/*
Copyright 2005 - 2017 by Paolo Brandoli/Binarno s.p.

Imebra is available for free under the GNU General Public License.

The full text of the license is available in the file license.rst
 in the project root folder.

If you do not want to be bound by the GPL terms (such as the requirement
 that your application must also be GPL), you may purchase a commercial
 license for Imebra from the Imebra’s website (http://imebra.com).
*/

/*! \file dimse.cpp
    \brief Implementation of the the DIMSE classes.
*/

#include "../include/imebra/dimse.h"
#include "../include/imebra/dataSet.h"
#include "../implementation/dimseImpl.h"
#include <typeinfo>

namespace imebra
{

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// DimseCommandBase
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
DimseCommandBase::DimseCommandBase(std::shared_ptr<implementation::dimseCommandBase> pCommand):
    m_pCommand(pCommand)
{
}


//////////////////////////////////////////////////////////////////
//
// Destructor
//
//////////////////////////////////////////////////////////////////
DimseCommandBase::~DimseCommandBase()
{
}


//////////////////////////////////////////////////////////////////
//
// Return the command DataSet.
//
//////////////////////////////////////////////////////////////////
DataSet* DimseCommandBase::getCommandDataSet() const
{
    return new DataSet(m_pCommand->getCommandDataSet());
}


//////////////////////////////////////////////////////////////////
//
// Return the command payload.
//
//////////////////////////////////////////////////////////////////
DataSet* DimseCommandBase::getPayloadDataSet() const
{
    return new DataSet(m_pCommand->getPayloadDataSet());
}


std::string DimseCommandBase::getAbstractSyntax() const
{
    return m_pCommand->getAbstractSyntax();
}


//////////////////////////////////////////////////////////////////
//
// Get the affected SOP instance UID
//
//////////////////////////////////////////////////////////////////
std::string DimseCommandBase::getAffectedSopInstanceUid() const
{
    return (std::static_pointer_cast<implementation::dimseCCommand>(m_pCommand))->getAffectedSopInstanceUid();
}


//////////////////////////////////////////////////////////////////
//
// Get the affected SOP class UID
//
//////////////////////////////////////////////////////////////////
std::string DimseCommandBase::getAffectedSopClassUid() const
{
    return (std::static_pointer_cast<implementation::dimseCCommand>(m_pCommand))->getAffectedSopClassUid();
}


//////////////////////////////////////////////////////////////////
//
// Get the requested SOP instance UID
//
//////////////////////////////////////////////////////////////////
std::string DimseCommandBase::getRequestedSopInstanceUid() const
{
    return (std::static_pointer_cast<implementation::dimseCCommand>(m_pCommand))->getRequestedSopInstanceUid();
}


//////////////////////////////////////////////////////////////////
//
// Get the requested SOP class UID
//
//////////////////////////////////////////////////////////////////
std::string DimseCommandBase::getRequestedSopClassUid() const
{
    return (std::static_pointer_cast<implementation::dimseCCommand>(m_pCommand))->getRequestedSopClassUid();
}



//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// DimseCommand
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
DimseCommand::DimseCommand(std::shared_ptr<implementation::dimseNCommand> pCommand):
    DimseCommandBase(pCommand)
{
}


//////////////////////////////////////////////////////////////////
//
// Get the command ID
//
//////////////////////////////////////////////////////////////////
std::uint16_t DimseCommand::getID() const
{
    return (std::static_pointer_cast<implementation::dimseCCommand>(m_pCommand))->getID();
}


//////////////////////////////////////////////////////////////////
//
// Get the command type
//
//////////////////////////////////////////////////////////////////
dimseCommandType_t DimseCommand::getCommandType() const
{
    return (std::static_pointer_cast<implementation::dimseNCommand>(m_pCommand))->getCommandType();
}


//////////////////////////////////////////////////////////////////
//
// Get the command as a CStoreCommand
//
//////////////////////////////////////////////////////////////////
const CStoreCommand* DimseCommand::getAsCStoreCommand() const
{
    std::shared_ptr<implementation::cStoreCommand> pCommand(std::dynamic_pointer_cast<implementation::cStoreCommand>(m_pCommand));
    if(pCommand.get() == nullptr)
    {
        throw std::bad_cast();
    }
    return new const CStoreCommand(pCommand);
}


//////////////////////////////////////////////////////////////////
//
// Get the command as a CMoveCommand
//
//////////////////////////////////////////////////////////////////
const CMoveCommand* DimseCommand::getAsCMoveCommand() const
{
    std::shared_ptr<implementation::cMoveCommand> pCommand(std::dynamic_pointer_cast<implementation::cMoveCommand>(m_pCommand));
    if(pCommand.get() == nullptr)
    {
        throw std::bad_cast();
    }
    return new const CMoveCommand(pCommand);
}


//////////////////////////////////////////////////////////////////
//
// Get the command as a CGetCommand
//
//////////////////////////////////////////////////////////////////
const CGetCommand* DimseCommand::getAsCGetCommand() const
{
    std::shared_ptr<implementation::cGetCommand> pCommand(std::dynamic_pointer_cast<implementation::cGetCommand>(m_pCommand));
    if(pCommand.get() == nullptr)
    {
        throw std::bad_cast();
    }
    return new const CGetCommand(pCommand);
}


//////////////////////////////////////////////////////////////////
//
// Get the command as a CFindCommand
//
//////////////////////////////////////////////////////////////////
const CFindCommand* DimseCommand::getAsCFindCommand() const
{
    std::shared_ptr<implementation::cFindCommand> pCommand(std::dynamic_pointer_cast<implementation::cFindCommand>(m_pCommand));
    if(pCommand.get() == nullptr)
    {
        throw std::bad_cast();
    }
    return new const CFindCommand(pCommand);
}


//////////////////////////////////////////////////////////////////
//
// Get the command as a CEchoCommand
//
//////////////////////////////////////////////////////////////////
const CEchoCommand* DimseCommand::getAsCEchoCommand() const
{
    std::shared_ptr<implementation::cEchoCommand> pCommand(std::dynamic_pointer_cast<implementation::cEchoCommand>(m_pCommand));
    if(pCommand.get() == nullptr)
    {
        throw std::bad_cast();
    }
    return new const CEchoCommand(pCommand);
}


//////////////////////////////////////////////////////////////////
//
// Get the command as a CCancelCommand
//
//////////////////////////////////////////////////////////////////
const CCancelCommand* DimseCommand::getAsCCancelCommand() const
{
    std::shared_ptr<implementation::cCancelCommand> pCommand(std::dynamic_pointer_cast<implementation::cCancelCommand>(m_pCommand));
    if(pCommand.get() == nullptr)
    {
        throw std::bad_cast();
    }
    return new const CCancelCommand(pCommand);
}


//////////////////////////////////////////////////////////////////
//
// Get the command as a NActionCommand
//
//////////////////////////////////////////////////////////////////
const NActionCommand* DimseCommand::getAsNActionCommand() const
{
    std::shared_ptr<implementation::nActionCommand> pCommand(std::dynamic_pointer_cast<implementation::nActionCommand>(m_pCommand));
    if(pCommand.get() == nullptr)
    {
        throw std::bad_cast();
    }
    return new const NActionCommand(pCommand);
}


//////////////////////////////////////////////////////////////////
//
// Get the command as a NEventReportCommand
//
//////////////////////////////////////////////////////////////////
const NEventReportCommand* DimseCommand::getAsNEventReportCommand() const
{
    std::shared_ptr<implementation::nEventReportCommand> pCommand(std::dynamic_pointer_cast<implementation::nEventReportCommand>(m_pCommand));
    if(pCommand.get() == nullptr)
    {
        throw std::bad_cast();
    }
    return new const NEventReportCommand(pCommand);
}


//////////////////////////////////////////////////////////////////
//
// Get the command as a NCreate
//
//////////////////////////////////////////////////////////////////
const NCreateCommand* DimseCommand::getAsNCreateCommand() const
{
    std::shared_ptr<implementation::nCreateCommand> pCommand(std::dynamic_pointer_cast<implementation::nCreateCommand>(m_pCommand));
    if(pCommand.get() == nullptr)
    {
        throw std::bad_cast();
    }
    return new const NCreateCommand(pCommand);
}


//////////////////////////////////////////////////////////////////
//
// Get the command as a NDeleteCommand
//
//////////////////////////////////////////////////////////////////
const NDeleteCommand* DimseCommand::getAsNDeleteCommand() const
{
    std::shared_ptr<implementation::nDeleteCommand> pCommand(std::dynamic_pointer_cast<implementation::nDeleteCommand>(m_pCommand));
    if(pCommand.get() == nullptr)
    {
        throw std::bad_cast();
    }
    return new const NDeleteCommand(pCommand);
}


//////////////////////////////////////////////////////////////////
//
// Get the command as a NSetCommand
//
//////////////////////////////////////////////////////////////////
const NSetCommand* DimseCommand::getAsNSetCommand() const
{
    std::shared_ptr<implementation::nSetCommand> pCommand(std::dynamic_pointer_cast<implementation::nSetCommand>(m_pCommand));
    if(pCommand.get() == nullptr)
    {
        throw std::bad_cast();
    }
    return new const NSetCommand(pCommand);
}


//////////////////////////////////////////////////////////////////
//
// Get the command as a NGetCommand
//
//////////////////////////////////////////////////////////////////
const NGetCommand* DimseCommand::getAsNGetCommand() const
{
    std::shared_ptr<implementation::nGetCommand> pCommand(std::dynamic_pointer_cast<implementation::nGetCommand>(m_pCommand));
    if(pCommand.get() == nullptr)
    {
        throw std::bad_cast();
    }
    return new const NGetCommand(pCommand);
}



//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// DimseResponse
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
DimseResponse::DimseResponse(std::shared_ptr<implementation::dimseResponse> pResponse):
    DimseCommandBase(pResponse)
{
}


//////////////////////////////////////////////////////////////////
//
// Get the response status
//
//////////////////////////////////////////////////////////////////
dimseStatus_t DimseResponse::getStatus() const
{
    return std::static_pointer_cast<implementation::dimseResponse>(m_pCommand)->getStatus();
}


//////////////////////////////////////////////////////////////////
//
// Get the response status code
//
//////////////////////////////////////////////////////////////////
std::uint16_t DimseResponse::getStatusCode() const
{
    return std::static_pointer_cast<implementation::dimseResponse>(m_pCommand)->getStatusCode();
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// CStoreCommand
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
CStoreCommand::CStoreCommand(std::shared_ptr<implementation::cStoreCommand> pCommand):
    DimseCommand(pCommand)
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
CStoreCommand::CStoreCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        dimseCommandPriority_t priority,
        const std::string& affectedSopClassUid,
        const std::string& affectedSopInstanceUid,
        const std::string& originatorAET,
        std::uint16_t originatorMessageID,
        const DataSet& payload):
    DimseCommand(std::make_shared<implementation::cStoreCommand>(
                     abstractSyntax,
                     messageID,
                     priority,
                     affectedSopClassUid,
                     affectedSopInstanceUid,
                     originatorAET,
                     originatorMessageID,
                     payload.m_pDataSet))
{
}


//////////////////////////////////////////////////////////////////
//
// Get the originator AET
//
//////////////////////////////////////////////////////////////////
std::string CStoreCommand::getOriginatorAET() const
{
    return (std::static_pointer_cast<implementation::cStoreCommand>(m_pCommand))->getOriginatorAET();
}


//////////////////////////////////////////////////////////////////
//
// Get the originator message ID
//
//////////////////////////////////////////////////////////////////
std::uint16_t CStoreCommand::getOriginatorMessageID() const
{
    return (std::static_pointer_cast<implementation::cStoreCommand>(m_pCommand))->getOriginatorMessageID();
}



//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// CStoreCommand
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructors
//
//////////////////////////////////////////////////////////////////
CStoreResponse::CStoreResponse(std::shared_ptr<implementation::cStoreResponse> pResponse):
    DimseResponse(pResponse)
{
}

CStoreResponse::CStoreResponse(const CStoreCommand& command, dimseStatusCode_t responseCode):
    DimseResponse(std::make_shared<implementation::cStoreResponse>(
                      std::static_pointer_cast<implementation::cStoreCommand>(command.m_pCommand), responseCode))
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// CGetCommand
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
CGetCommand::CGetCommand(std::shared_ptr<implementation::cGetCommand> pCommand):
    DimseCommand(pCommand)
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
CGetCommand::CGetCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        dimseCommandPriority_t priority,
        const std::string& affectedSopClassUid,
        const DataSet& identifier):
    DimseCommand(std::make_shared<implementation::cGetCommand>(
                     abstractSyntax,
                     messageID,
                     priority,
                     affectedSopClassUid,
                     identifier.m_pDataSet))
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// CPartialResponse
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
CPartialResponse::CPartialResponse(std::shared_ptr<implementation::cPartialResponse> pResponse):
    DimseResponse(pResponse)
{
}


//////////////////////////////////////////////////////////////////
//
// Get the number of remaining sub operations
//
//////////////////////////////////////////////////////////////////
std::uint32_t CPartialResponse::getRemainingSubOperations() const
{
    return (std::static_pointer_cast<implementation::cPartialResponse>(m_pCommand))->getRemainingSubOperations();
}


//////////////////////////////////////////////////////////////////
//
// Get the number of completed sub operations
//
//////////////////////////////////////////////////////////////////
std::uint32_t CPartialResponse::getCompletedSubOperations() const
{
    return (std::static_pointer_cast<implementation::cPartialResponse>(m_pCommand))->getCompletedSubOperations();
}


//////////////////////////////////////////////////////////////////
//
// Get the number of failed sub operations
//
//////////////////////////////////////////////////////////////////
std::uint32_t CPartialResponse::getFailedSubOperations() const
{
    return (std::static_pointer_cast<implementation::cPartialResponse>(m_pCommand))->getFailedSubOperations();
}


//////////////////////////////////////////////////////////////////
//
// Get the number of sub operations completed with warnings
//
//////////////////////////////////////////////////////////////////
std::uint32_t CPartialResponse::getWarningSubOperations() const
{
    return (std::static_pointer_cast<implementation::cPartialResponse>(m_pCommand))->getWarningSubOperations();
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// CGetResponse
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructors
//
//////////////////////////////////////////////////////////////////
CGetResponse::CGetResponse(std::shared_ptr<implementation::cGetResponse> pResponse):
    CPartialResponse(pResponse)
{
}

CGetResponse::CGetResponse(
        const CGetCommand& receivedCommand,
        dimseStatusCode_t responseCode,
        std::uint32_t remainingSubOperations,
        std::uint32_t completedSubOperations,
        std::uint32_t failedSubOperations,
        std::uint32_t warningSubOperations,
        const DataSet& identifier):
    CGetResponse(
        std::make_shared<implementation::cGetResponse>(
            std::static_pointer_cast<implementation::cGetCommand>(receivedCommand.m_pCommand),
            responseCode,
            remainingSubOperations,
            completedSubOperations,
            failedSubOperations,
            warningSubOperations,
            identifier.m_pDataSet
            ))
{
}

CGetResponse::CGetResponse(
        const CGetCommand& receivedCommand,
        dimseStatusCode_t responseCode,
        std::uint32_t remainingSubOperations,
        std::uint32_t completedSubOperations,
        std::uint32_t failedSubOperations,
        std::uint32_t warningSubOperations):
    CGetResponse(
        std::make_shared<implementation::cGetResponse>(
            std::static_pointer_cast<implementation::cGetCommand>(receivedCommand.m_pCommand),
            responseCode,
            remainingSubOperations,
            completedSubOperations,
            failedSubOperations,
            warningSubOperations,
            nullptr
            ))
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// CFindCommand
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
CFindCommand::CFindCommand(std::shared_ptr<implementation::cFindCommand> pCommand):
    DimseCommand(pCommand)
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
CFindCommand::CFindCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        dimseCommandPriority_t priority,
        const std::string& affectedSopClassUid,
        const DataSet& identifier):
    DimseCommand(std::make_shared<implementation::cFindCommand>(
                     abstractSyntax,
                     messageID,
                     priority,
                     affectedSopClassUid,
                     identifier.m_pDataSet))
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// CFindResponse
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructors
//
//////////////////////////////////////////////////////////////////
CFindResponse::CFindResponse(std::shared_ptr<implementation::cFindResponse> pResponse):
    DimseResponse(pResponse)
{
}

CFindResponse::CFindResponse(
        const CFindCommand& receivedCommand,
        const DataSet& identifier):
    CFindResponse(
        std::make_shared<implementation::cFindResponse>(
            std::static_pointer_cast<implementation::cFindCommand>(receivedCommand.m_pCommand),
            identifier.m_pDataSet
            ))
{
}


CFindResponse::CFindResponse(
        const CFindCommand& receivedCommand,
        dimseStatusCode_t responseCode):
    CFindResponse(
        std::make_shared<implementation::cFindResponse>(
            std::static_pointer_cast<implementation::cFindCommand>(receivedCommand.m_pCommand),
            responseCode
            ))
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// CMoveCommand
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
CMoveCommand::CMoveCommand(std::shared_ptr<implementation::cMoveCommand> pCommand):
    DimseCommand(pCommand)
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor (deprecated)
//
//////////////////////////////////////////////////////////////////
CMoveCommand::CMoveCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        dimseCommandPriority_t priority,
        const std::string& affectedSopClassUid,
        const DataSet& identifier):
    DimseCommand(std::make_shared<implementation::cMoveCommand>(
                     abstractSyntax,
                     messageID,
                     priority,
                     affectedSopClassUid,
                     "",
                     identifier.m_pDataSet))
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
CMoveCommand::CMoveCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        dimseCommandPriority_t priority,
        const std::string& affectedSopClassUid,
        const std::string& destinationAET,
        const DataSet& identifier):
    DimseCommand(std::make_shared<implementation::cMoveCommand>(
                     abstractSyntax,
                     messageID,
                     priority,
                     affectedSopClassUid,
                     destinationAET,
                     identifier.m_pDataSet))
{
}


//////////////////////////////////////////////////////////////////
//
// Return the destination AET
//
//////////////////////////////////////////////////////////////////
std::string CMoveCommand::getDestinationAET() const
{
    return (std::static_pointer_cast<implementation::cMoveCommand>(m_pCommand))->getDestinationAET();
}


//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// CMoveResponse
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructors
//
//////////////////////////////////////////////////////////////////
CMoveResponse::CMoveResponse(std::shared_ptr<implementation::cMoveResponse> pResponse):
    CPartialResponse(pResponse)
{
}

CMoveResponse::CMoveResponse(
        const CMoveCommand& receivedCommand,
        dimseStatusCode_t responseCode,
        std::uint32_t remainingSubOperations,
        std::uint32_t completedSubOperations,
        std::uint32_t failedSubOperations,
        std::uint32_t warningSubOperations,
        const DataSet& identifier):
    CMoveResponse(
        std::make_shared<implementation::cMoveResponse>(
            std::static_pointer_cast<implementation::cMoveCommand>(receivedCommand.m_pCommand),
            responseCode,
            remainingSubOperations,
            completedSubOperations,
            failedSubOperations,
            warningSubOperations,
            identifier.m_pDataSet
            ))
{
}


CMoveResponse::CMoveResponse(
        const CMoveCommand& receivedCommand,
        dimseStatusCode_t responseCode,
        std::uint32_t remainingSubOperations,
        std::uint32_t completedSubOperations,
        std::uint32_t failedSubOperations,
        std::uint32_t warningSubOperations):
    CMoveResponse(
        std::make_shared<implementation::cMoveResponse>(
            std::static_pointer_cast<implementation::cMoveCommand>(receivedCommand.m_pCommand),
            responseCode,
            remainingSubOperations,
            completedSubOperations,
            failedSubOperations,
            warningSubOperations,
            nullptr
            ))
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// CEchoCommand
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
CEchoCommand::CEchoCommand(std::shared_ptr<implementation::cEchoCommand> pCommand):
    DimseCommand(pCommand)
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
CEchoCommand::CEchoCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        dimseCommandPriority_t priority,
        const std::string& affectedSopClassUid):
    DimseCommand(std::make_shared<implementation::cEchoCommand>(
                     abstractSyntax,
                     messageID,
                     priority,
                     affectedSopClassUid))
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// CEchoResponse
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructors
//
//////////////////////////////////////////////////////////////////
CEchoResponse::CEchoResponse(std::shared_ptr<implementation::cEchoResponse> pResponse):
    DimseResponse(pResponse)
{
}

CEchoResponse::CEchoResponse(
        const CEchoCommand& receivedCommand,
        dimseStatusCode_t responseCode):
    DimseResponse(
        std::make_shared<implementation::cEchoResponse>(
            std::static_pointer_cast<implementation::cEchoCommand>(receivedCommand.m_pCommand),
            responseCode
            ))
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// CCancelCommand
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
CCancelCommand::CCancelCommand(std::shared_ptr<implementation::cCancelCommand> pCommand):
    DimseCommand(pCommand)
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
CCancelCommand::CCancelCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        dimseCommandPriority_t priority,
        std::uint16_t cancelMessageID):
    DimseCommand(std::make_shared<implementation::cCancelCommand>(
                     abstractSyntax,
                     messageID,
                     priority,
                     cancelMessageID))
{
}


//////////////////////////////////////////////////////////////////
//
// Return the ID of the command to cancel
//
//////////////////////////////////////////////////////////////////
std::uint16_t CCancelCommand::getCancelMessageID() const
{
    return (std::static_pointer_cast<implementation::cCancelCommand>(m_pCommand))->getCancelMessageID();
}


DimseService::DimseService(AssociationBase& association):
    m_pDimseService(std::make_shared<implementation::dimseService>(association.m_pAssociation))
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// NEventReportCommand
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NEventReportCommand::NEventReportCommand(std::shared_ptr<implementation::nEventReportCommand> pCommand):
    DimseCommand(pCommand)
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NEventReportCommand::NEventReportCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        const std::string& affectedSopClassUid,
        const std::string& affectedSopInstanceUid,
        std::uint16_t eventID
        ):
    DimseCommand(std::make_shared<implementation::nEventReportCommand>(
                     abstractSyntax,
                     messageID,
                     affectedSopClassUid,
                     affectedSopInstanceUid,
                     eventID))
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NEventReportCommand::NEventReportCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        const std::string& affectedSopClassUid,
        const std::string& affectedSopInstanceUid,
        std::uint16_t eventID,
        const DataSet& eventInformation
        ):
    DimseCommand(std::make_shared<implementation::nEventReportCommand>(
                     abstractSyntax,
                     messageID,
                     affectedSopClassUid,
                     affectedSopInstanceUid,
                     eventID,
                     eventInformation.m_pDataSet))
{
}


//////////////////////////////////////////////////////////////////
//
// Return the event ID
//
//////////////////////////////////////////////////////////////////
std::uint16_t NEventReportCommand::getEventID() const
{
    return (std::static_pointer_cast<implementation::nEventReportCommand>(m_pCommand))->getEventID();
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// NEventReportResponses
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructors
//
//////////////////////////////////////////////////////////////////
NEventReportResponse::NEventReportResponse(std::shared_ptr<implementation::nEventReportResponse> pResponse):
    DimseResponse(pResponse)
{
}


NEventReportResponse::NEventReportResponse(
        const NEventReportCommand& receivedCommand,
        const DataSet& eventReply
        ):
    DimseResponse(
        std::make_shared<implementation::nEventReportResponse>(
            std::static_pointer_cast<implementation::nEventReportCommand>(receivedCommand.m_pCommand),
            eventReply.m_pDataSet) )
{
}


NEventReportResponse::NEventReportResponse(
        const NEventReportCommand& receivedCommand,
        dimseStatusCode_t responseCode
        ):
    DimseResponse(
        std::make_shared<implementation::nEventReportResponse>(
            std::static_pointer_cast<implementation::nEventReportCommand>(receivedCommand.m_pCommand),
            responseCode) )
{
}


//////////////////////////////////////////////////////////////////
//
// Return the event ID
//
//////////////////////////////////////////////////////////////////
std::uint16_t NEventReportResponse::getEventID() const
{
    return (std::static_pointer_cast<implementation::nEventReportResponse>(m_pCommand))->getEventID();
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// NGetCommand
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NGetCommand::NGetCommand(std::shared_ptr<implementation::nGetCommand> pCommand):
    DimseCommand(pCommand)
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NGetCommand::NGetCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        const std::string& requestedSopClassUid,
        const std::string& requestedSopInstanceUid,
        const attributeIdentifierList_t& attributeIdentifierList
        ):
    DimseCommand(std::make_shared<implementation::nGetCommand>(
                     abstractSyntax,
                     messageID,
                     requestedSopClassUid,
                     requestedSopInstanceUid,
                     attributeIdentifierList))
{
}


//////////////////////////////////////////////////////////////////
//
// Return the attribute list
//
//////////////////////////////////////////////////////////////////
attributeIdentifierList_t NGetCommand::getAttributeList() const
{
    return (std::static_pointer_cast<implementation::nGetCommand>(m_pCommand))->getAttributeList();
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// NGetResponse
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructors
//
//////////////////////////////////////////////////////////////////
NGetResponse::NGetResponse(std::shared_ptr<implementation::nGetResponse> pResponse):
    DimseResponse(pResponse)
{
}


NGetResponse::NGetResponse(
        const NGetCommand& receivedCommand,
        dimseStatusCode_t responseCode,
        const DataSet& attributeList
        ):
    DimseResponse(
        std::make_shared<implementation::nGetResponse>(
            std::static_pointer_cast<implementation::nGetCommand>(receivedCommand.m_pCommand),
            responseCode,
            attributeList.m_pDataSet) )
{
}


NGetResponse::NGetResponse(
        const NGetCommand& receivedCommand,
        dimseStatusCode_t responseCode
        ):
    DimseResponse(
        std::make_shared<implementation::nGetResponse>(
            std::static_pointer_cast<implementation::nGetCommand>(receivedCommand.m_pCommand),
            responseCode) )
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// NSetCommand
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NSetCommand::NSetCommand(std::shared_ptr<implementation::nSetCommand> pCommand):
    DimseCommand(pCommand)
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NSetCommand::NSetCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        const std::string& requestedSopClassUid,
        const std::string& requestedSopInstanceUid,
        const DataSet& modificationList
        ):
    DimseCommand(std::make_shared<implementation::nSetCommand>(
                     abstractSyntax,
                     messageID,
                     requestedSopClassUid,
                     requestedSopInstanceUid,
                     modificationList.m_pDataSet))
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// NSetResponse
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructors
//
//////////////////////////////////////////////////////////////////
NSetResponse::NSetResponse(std::shared_ptr<implementation::nSetResponse> pResponse):
    DimseResponse(pResponse)
{
}


NSetResponse::NSetResponse(
        const NSetCommand& receivedCommand,
        attributeIdentifierList_t modifiedAttributes
        ):
    DimseResponse(
        std::make_shared<implementation::nSetResponse>(
            std::static_pointer_cast<implementation::nSetCommand>(receivedCommand.m_pCommand),
            modifiedAttributes) )
{
}


NSetResponse::NSetResponse(
        const NSetCommand& receivedCommand,
        dimseStatusCode_t responseCode
        ):
    DimseResponse(
        std::make_shared<implementation::nSetResponse>(
            std::static_pointer_cast<implementation::nSetCommand>(receivedCommand.m_pCommand),
            responseCode) )
{
}


//////////////////////////////////////////////////////////////////
//
// Get the list of modified attributes
//
//////////////////////////////////////////////////////////////////
attributeIdentifierList_t NSetResponse::getModifiedAttributes() const
{
    return (std::static_pointer_cast<implementation::nSetResponse>(m_pCommand))->getModifiedAttributes();
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// NActionCommand
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NActionCommand::NActionCommand(std::shared_ptr<implementation::nActionCommand> pCommand):
    DimseCommand(pCommand)
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NActionCommand::NActionCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        const std::string& requestedSopClassUid,
        const std::string& requestedSopInstanceUid,
        std::uint16_t actionID,
        const DataSet& actionInformation
        ):
    DimseCommand(std::make_shared<implementation::nActionCommand>(
                     abstractSyntax,
                     messageID,
                     requestedSopClassUid,
                     requestedSopInstanceUid,
                     actionID,
                     actionInformation.m_pDataSet))
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NActionCommand::NActionCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        const std::string& requestedSopClassUid,
        const std::string& requestedSopInstanceUid,
        std::uint16_t actionID
        ):
    DimseCommand(std::make_shared<implementation::nActionCommand>(
                     abstractSyntax,
                     messageID,
                     requestedSopClassUid,
                     requestedSopInstanceUid,
                     actionID))
{
}



//////////////////////////////////////////////////////////////////
//
// Return the action ID
//
//////////////////////////////////////////////////////////////////
std::uint16_t NActionCommand::getActionID() const
{
    return (std::static_pointer_cast<implementation::nActionCommand>(m_pCommand))->getActionID();
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// NActionResponse
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructors
//
//////////////////////////////////////////////////////////////////
NActionResponse::NActionResponse(std::shared_ptr<implementation::nActionResponse> pResponse):
    DimseResponse(pResponse)
{
}


NActionResponse::NActionResponse(
        const NActionCommand& receivedCommand,
        const DataSet& actionReply
        ):
    DimseResponse(
        std::make_shared<implementation::nActionResponse>(
            std::static_pointer_cast<implementation::nActionCommand>(receivedCommand.m_pCommand),
            actionReply.m_pDataSet) )
{
}


NActionResponse::NActionResponse(
        const NActionCommand& receivedCommand,
        dimseStatusCode_t responseCode
        ):
    DimseResponse(
        std::make_shared<implementation::nActionResponse>(
            std::static_pointer_cast<implementation::nActionCommand>(receivedCommand.m_pCommand),
            responseCode) )
{
}


std::uint16_t NActionResponse::getActionID() const
{
    return (std::static_pointer_cast<implementation::nActionResponse>(m_pCommand))->getActionID();
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// NCreateCommand
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NCreateCommand::NCreateCommand(std::shared_ptr<implementation::nCreateCommand> pCommand):
    DimseCommand(pCommand)
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NCreateCommand::NCreateCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        const std::string& affectedSopClassUid,
        const std::string& affectedSopInstanceUid,
        const DataSet& attributeList
        ):
    DimseCommand(std::make_shared<implementation::nCreateCommand>(
                     abstractSyntax,
                     messageID,
                     affectedSopClassUid,
                     affectedSopInstanceUid,
                     attributeList.m_pDataSet))
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NCreateCommand::NCreateCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        const std::string& affectedSopClassUid,
        const std::string& affectedSopInstanceUid
        ):
    DimseCommand(std::make_shared<implementation::nCreateCommand>(
                     abstractSyntax,
                     messageID,
                     affectedSopClassUid,
                     affectedSopInstanceUid))
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// NCreateResponse
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructors
//
//////////////////////////////////////////////////////////////////
NCreateResponse::NCreateResponse(std::shared_ptr<implementation::nCreateResponse> pResponse):
    DimseResponse(pResponse)
{
}


NCreateResponse::NCreateResponse(
        const NCreateCommand& receivedCommand,
        const DataSet& attributeList
        ):
    DimseResponse(
        std::make_shared<implementation::nCreateResponse>(
            std::static_pointer_cast<implementation::nCreateCommand>(receivedCommand.m_pCommand),
            attributeList.m_pDataSet) )
{
}


NCreateResponse::NCreateResponse(
        const NCreateCommand& receivedCommand,
        const std::string& affectedSopInstanceUid,
        const DataSet& attributeList
        ):
    DimseResponse(
        std::make_shared<implementation::nCreateResponse>(
            std::static_pointer_cast<implementation::nCreateCommand>(receivedCommand.m_pCommand),
            affectedSopInstanceUid,
            attributeList.m_pDataSet) )
{
}


NCreateResponse::NCreateResponse(
        const NCreateCommand& receivedCommand,
        dimseStatusCode_t responseCode
        ):
    DimseResponse(
        std::make_shared<implementation::nCreateResponse>(
            std::static_pointer_cast<implementation::nCreateCommand>(receivedCommand.m_pCommand),
            responseCode) )
{
}


NCreateResponse::NCreateResponse(
        const NCreateCommand& receivedCommand,
        const std::string& affectedSopInstanceUid
        ):
    DimseResponse(
        std::make_shared<implementation::nCreateResponse>(
            std::static_pointer_cast<implementation::nCreateCommand>(receivedCommand.m_pCommand),
            affectedSopInstanceUid) )
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// NDeleteCommand
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NDeleteCommand::NDeleteCommand(std::shared_ptr<implementation::nDeleteCommand> pCommand):
    DimseCommand(pCommand)
{
}


//////////////////////////////////////////////////////////////////
//
// Constructor
//
//////////////////////////////////////////////////////////////////
NDeleteCommand::NDeleteCommand(
        const std::string& abstractSyntax,
        std::uint16_t messageID,
        const std::string& requestedSopClassUid,
        const std::string& requestedSopInstanceUid
        ):
    DimseCommand(std::make_shared<implementation::nDeleteCommand>(
                     abstractSyntax,
                     messageID,
                     requestedSopClassUid,
                     requestedSopInstanceUid))
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// NDeleteResponse
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Constructors
//
//////////////////////////////////////////////////////////////////
NDeleteResponse::NDeleteResponse(std::shared_ptr<implementation::nDeleteResponse> pResponse):
    DimseResponse(pResponse)
{
}


NDeleteResponse::NDeleteResponse(
        NDeleteCommand& receivedCommand,
        dimseStatusCode_t responseCode
        ):
    DimseResponse(
        std::make_shared<implementation::nDeleteResponse>(
            std::static_pointer_cast<implementation::nDeleteCommand>(receivedCommand.m_pCommand),
            responseCode) )
{
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// DimseService
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//
// Get an ID for the next command
//
//////////////////////////////////////////////////////////////////
std::uint16_t DimseService::getNextCommandID()
{
    return m_pDimseService->getNextCommandID();
}


//////////////////////////////////////////////////////////////////
//
// Get the next command
//
//////////////////////////////////////////////////////////////////
DimseCommand* DimseService::getCommand()
{
    IMEBRA_FUNCTION_START();

    std::shared_ptr<implementation::dimseNCommand> pCommand(m_pDimseService->getCommand());

    switch(pCommand->getCommandType())
    {
    case dimseCommandType_t::cStore:
        return new CStoreCommand(std::dynamic_pointer_cast<implementation::cStoreCommand>(pCommand));
    case dimseCommandType_t::cGet:
        return new CGetCommand(std::dynamic_pointer_cast<implementation::cGetCommand>(pCommand));
    case dimseCommandType_t::cMove:
        return new CMoveCommand(std::dynamic_pointer_cast<implementation::cMoveCommand>(pCommand));
    case dimseCommandType_t::cFind:
        return new CFindCommand(std::dynamic_pointer_cast<implementation::cFindCommand>(pCommand));
    case dimseCommandType_t::cEcho:
        return new CEchoCommand(std::dynamic_pointer_cast<implementation::cEchoCommand>(pCommand));
    case dimseCommandType_t::cCancel:
        return new CCancelCommand(std::dynamic_pointer_cast<implementation::cCancelCommand>(pCommand));
    case dimseCommandType_t::nEventReport:
        return new NEventReportCommand(std::dynamic_pointer_cast<implementation::nEventReportCommand>(pCommand));
    case dimseCommandType_t::nGet:
        return new NGetCommand(std::dynamic_pointer_cast<implementation::nGetCommand>(pCommand));
    case dimseCommandType_t::nSet:
        return new NSetCommand(std::dynamic_pointer_cast<implementation::nSetCommand>(pCommand));
    case dimseCommandType_t::nAction:
        return new NActionCommand(std::dynamic_pointer_cast<implementation::nActionCommand>(pCommand));
    case dimseCommandType_t::nCreate:
        return new NCreateCommand(std::dynamic_pointer_cast<implementation::nCreateCommand>(pCommand));
    case dimseCommandType_t::nDelete:
        return new NDeleteCommand(std::dynamic_pointer_cast<implementation::nDeleteCommand>(pCommand));
    default:
        {}
    }

    IMEBRA_THROW(std::logic_error, "Should have received a valid command from the implementation layer");

    IMEBRA_FUNCTION_END();
}


//////////////////////////////////////////////////////////////////
//
// Returns the transfer syntax for a specific abstract syntax
//
//////////////////////////////////////////////////////////////////
std::string DimseService::getTransferSyntax(const std::string &abstractSyntax) const
{
    return m_pDimseService->getTransferSyntax(abstractSyntax);
}


//////////////////////////////////////////////////////////////////
//
// Send a command or response
//
//////////////////////////////////////////////////////////////////
void DimseService::sendCommandOrResponse(const DimseCommandBase &command)
{
    m_pDimseService->sendCommandOrResponse(command.m_pCommand);
}


//////////////////////////////////////////////////////////////////
//
// Wait for a C-STORE response
//
//////////////////////////////////////////////////////////////////
CStoreResponse* DimseService::getCStoreResponse(const CStoreCommand& command)
{
    return new CStoreResponse(m_pDimseService->getResponse<implementation::cStoreResponse>(command.getID()));
}


//////////////////////////////////////////////////////////////////
//
// Wait for a C-GET response
//
//////////////////////////////////////////////////////////////////
CGetResponse* DimseService::getCGetResponse(const CGetCommand& command)
{
    return new CGetResponse(m_pDimseService->getResponse<implementation::cGetResponse>(command.getID()));
}


//////////////////////////////////////////////////////////////////
//
// Wait for a C-FIND response
//
//////////////////////////////////////////////////////////////////
CFindResponse* DimseService::getCFindResponse(const CFindCommand& command)
{
    return new CFindResponse(m_pDimseService->getResponse<implementation::cFindResponse>(command.getID()));
}


//////////////////////////////////////////////////////////////////
//
// Wait for a C-MOVE response
//
//////////////////////////////////////////////////////////////////
CMoveResponse* DimseService::getCMoveResponse(const CMoveCommand& command)
{
    return new CMoveResponse(m_pDimseService->getResponse<implementation::cMoveResponse>(command.getID()));
}


//////////////////////////////////////////////////////////////////
//
// Wait for a C-ECHO response
//
//////////////////////////////////////////////////////////////////
CEchoResponse* DimseService::getCEchoResponse(const CEchoCommand& command)
{
    return new CEchoResponse(m_pDimseService->getResponse<implementation::cEchoResponse>(command.getID()));
}


//////////////////////////////////////////////////////////////////
//
// Wait for a N-EVENT-REPORT response
//
//////////////////////////////////////////////////////////////////
NEventReportResponse* DimseService::getNEventReportResponse(const NEventReportCommand& command)
{
    return new NEventReportResponse(m_pDimseService->getResponse<implementation::nEventReportResponse>(command.getID()));
}


//////////////////////////////////////////////////////////////////
//
// Wait for a N-GET response
//
//////////////////////////////////////////////////////////////////
NGetResponse* DimseService::getNGetResponse(const NGetCommand& command)
{
    return new NGetResponse(m_pDimseService->getResponse<implementation::nGetResponse>(command.getID()));
}


//////////////////////////////////////////////////////////////////
//
// Wait for a N-SET response
//
//////////////////////////////////////////////////////////////////
NSetResponse* DimseService::getNSetResponse(const NSetCommand& command)
{
    return new NSetResponse(m_pDimseService->getResponse<implementation::nSetResponse>(command.getID()));
}


//////////////////////////////////////////////////////////////////
//
// Wait for a N-ACTION response
//
//////////////////////////////////////////////////////////////////
NActionResponse* DimseService::getNActionResponse(const NActionCommand& command)
{
    return new NActionResponse(m_pDimseService->getResponse<implementation::nActionResponse>(command.getID()));
}


//////////////////////////////////////////////////////////////////
//
// Wait for a N-CREATE response
//
//////////////////////////////////////////////////////////////////
NCreateResponse* DimseService::getNCreateResponse(const NCreateCommand& command)
{
    return new NCreateResponse(m_pDimseService->getResponse<implementation::nCreateResponse>(command.getID()));
}


//////////////////////////////////////////////////////////////////
//
// Wait for a N-DELETE response
//
//////////////////////////////////////////////////////////////////
NDeleteResponse* DimseService::getNDeleteResponse(const NDeleteCommand& command)
{
    return new NDeleteResponse(m_pDimseService->getResponse<implementation::nDeleteResponse>(command.getID()));
}


} // namespace imebra
