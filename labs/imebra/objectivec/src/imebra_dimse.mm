/*
Copyright 2005 - 2017 by Paolo Brandoli/Binarno s.p.

Imebra is available for free under the GNU General Public License.

The full text of the license is available in the file license.rst
 in the project root folder.

If you do not want to be bound by the GPL terms (such as the requirement
 that your application must also be GPL), you may purchase a commercial
 license for Imebra from the Imebra’s website (http://imebra.com).
*/

#include "imebra_bridgeStructures.h"


@implementation ImebraDimseCommandBase

-(id)initWithImebraCommand:(imebra::DimseCommandBase*)pCommand
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = pCommand;
    }
    else
    {
        delete pCommand;
    }
    return self;

}


-(void)dealloc
{
    delete m_pDimseCommandBase;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif

}

-(ImebraDataSet*)getCommandDataSet:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraDataSet alloc] initWithImebraDataSet:m_pDimseCommandBase->getCommandDataSet()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraDataSet*)getPayloadDataSet:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraDataSet alloc] initWithImebraDataSet:m_pDimseCommandBase->getPayloadDataSet()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(NSString*)getAbstractSyntax
{
    return imebra::stringToNSString(m_pDimseCommandBase->getAbstractSyntax());
}

-(NSString*)getAffectedSopInstanceUid:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return imebra::stringToNSString(m_pDimseCommandBase->getAffectedSopInstanceUid());

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(NSString*)getAffectedSopClassUid:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return imebra::stringToNSString(m_pDimseCommandBase->getAffectedSopClassUid());

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(NSString*)getRequestedSopInstanceUid:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return imebra::stringToNSString(m_pDimseCommandBase->getRequestedSopInstanceUid());

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(NSString*)getRequestedSopClassUid:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return imebra::stringToNSString(m_pDimseCommandBase->getRequestedSopClassUid());

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


@end


@implementation ImebraDimseCommand

-(unsigned short) ID
{
    return (unsigned short)((imebra::DimseCommand*)m_pDimseCommandBase)->getID();
}

-(ImebraDimseCommandType_t) commandType
{
    return (ImebraDimseCommandType_t)((imebra::DimseCommand*)m_pDimseCommandBase)->getCommandType();
}

@end


@implementation ImebraDimseResponse

-(ImebraDimseStatus_t) status
{
    return (ImebraDimseStatus_t)((imebra::DimseResponse*)m_pDimseCommandBase)->getStatus();
}

-(unsigned short) statusCode
{
    return (unsigned short)((imebra::DimseResponse*)m_pDimseCommandBase)->getStatusCode();
}

@end


@implementation ImebraCPartialResponse

-(unsigned int)getRemainingSubOperations:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return (unsigned int)((imebra::CPartialResponse*)m_pDimseCommandBase)->getRemainingSubOperations();

    OBJC_IMEBRA_FUNCTION_END_RETURN(0);
}

-(unsigned int)getCompletedSubOperations:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return (unsigned int)((imebra::CPartialResponse*)m_pDimseCommandBase)->getCompletedSubOperations();

    OBJC_IMEBRA_FUNCTION_END_RETURN(0);
}

-(unsigned int)getFailedSubOperations:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return (unsigned int)((imebra::CPartialResponse*)m_pDimseCommandBase)->getFailedSubOperations();

    OBJC_IMEBRA_FUNCTION_END_RETURN(0);
}


-(unsigned int)getWarningSubOperations:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return (unsigned int)((imebra::CPartialResponse*)m_pDimseCommandBase)->getWarningSubOperations();

    OBJC_IMEBRA_FUNCTION_END_RETURN(0);
}

@end


@implementation ImebraCStoreCommand

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    priority:(ImebraDimseCommandPriority_t)priority
    affectedSopClassUid:(NSString*)affectedSopClassUid
    affectedSopInstanceUid:(NSString*)affectedSopInstanceUid
    originatorAET:(NSString*)originatorAET
    originatorMessageID:(unsigned short)originatorMessageID
    payload:(ImebraDataSet*)pPayload
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::CStoreCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    (imebra::dimseCommandPriority_t)priority,
                    imebra::NSStringToString(affectedSopClassUid),
                    imebra::NSStringToString(affectedSopInstanceUid),
                    imebra::NSStringToString(originatorAET),
                    (std::uint16_t)originatorMessageID,
                    *(pPayload->m_pDataSet));
    }
    return self;

}


-(NSString*) originatorAET
{
    return imebra::stringToNSString(((imebra::CStoreCommand*)m_pDimseCommandBase)->getOriginatorAET());
}

-(unsigned short) originatorMessageID
{
    return (unsigned short)((imebra::CStoreCommand*)m_pDimseCommandBase)->getOriginatorMessageID();
}

@end


@implementation ImebraCStoreResponse

-(id)initWithcommand:(ImebraCStoreCommand*)pCommand
    responseCode:(ImebraDimseStatusCode_t)responseCode
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::CStoreResponse(
                    *(imebra::CStoreCommand*)pCommand->m_pDimseCommandBase,
                    (imebra::dimseStatusCode_t)responseCode);
    }
    return self;

}

@end


@implementation ImebraCGetCommand

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    priority:(ImebraDimseCommandPriority_t)priority
    affectedSopClassUid:(NSString*)affectedSopClassUid
    identifier:(ImebraDataSet*)pIdentifier
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::CGetCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    (imebra::dimseCommandPriority_t)priority,
                    imebra::NSStringToString(affectedSopClassUid),
                    *(pIdentifier->m_pDataSet));
    }
    return self;
}

@end


@implementation ImebraCGetResponse

-(id)initWithCommand:(ImebraCGetCommand*)pReceivedCommand
    responseCode:(ImebraDimseStatusCode_t)responseCode
    remainingSubOperations:(unsigned int)remainingSubOperations
    completedSubOperations:(unsigned int)completedSubOperations
    failedSubOperations:(unsigned int)failedSubOperations
    warningSubOperations:(unsigned int)warningSubOperations
    identifier:(ImebraDataSet*)pIdentifier
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::CGetResponse(
                    *(imebra::CGetCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    (imebra::dimseStatusCode_t)responseCode,
                    (std::uint32_t)remainingSubOperations,
                    (std::uint32_t)completedSubOperations,
                    (std::uint32_t)failedSubOperations,
                    (std::uint32_t)warningSubOperations,
                    *(pIdentifier->m_pDataSet));
    }
    return self;
}

-(id)initWithcommand:(ImebraCGetCommand*)pReceivedCommand
    responseCode:(ImebraDimseStatusCode_t)responseCode
    remainingSubOperations:(unsigned int)remainingSubOperations
    completedSubOperations:(unsigned int)completedSubOperations
    failedSubOperations:(unsigned int)failedSubOperations
    warningSubOperations:(unsigned int)warningSubOperations
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::CGetResponse(
                    *(imebra::CGetCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    (imebra::dimseStatusCode_t)responseCode,
                    (std::uint32_t)remainingSubOperations,
                    (std::uint32_t)completedSubOperations,
                    (std::uint32_t)failedSubOperations,
                    (std::uint32_t)warningSubOperations);
    }
    return self;
}


@end


@implementation ImebraCFindCommand

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    priority:(ImebraDimseCommandPriority_t)priority
    affectedSopClassUid:(NSString*)affectedSopClassUid
    identifier:(ImebraDataSet*)pIdentifier
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::CFindCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    (imebra::dimseCommandPriority_t)priority,
                    imebra::NSStringToString(affectedSopClassUid),
                    *(pIdentifier->m_pDataSet));
    }
    return self;
}

@end


@implementation ImebraCFindResponse

-(id)initWithCommand:(ImebraCFindCommand*)pReceivedCommand
    identifier:(ImebraDataSet*)pIdentifier
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::CFindResponse(
                    *(imebra::CFindCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    *(pIdentifier->m_pDataSet));
    }
    return self;
}

-(id)initWithcommand:(ImebraCFindCommand*)pReceivedCommand
    responseCode:(ImebraDimseStatusCode_t)responseCode
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::CFindResponse(
                    *(imebra::CFindCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    (imebra::dimseStatusCode_t)responseCode);
    }
    return self;
}

@end


@implementation ImebraCMoveCommand

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    priority:(ImebraDimseCommandPriority_t)priority
    affectedSopClassUid:(NSString*)affectedSopClassUid
    destinationAET:(NSString*)destinationAET
    identifier:(ImebraDataSet*)pIdentifier
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::CMoveCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    (imebra::dimseCommandPriority_t)priority,
                    imebra::NSStringToString(affectedSopClassUid),
                    imebra::NSStringToString(destinationAET),
                    *(pIdentifier->m_pDataSet));
    }
    return self;
}

-(NSString*)getDestinationAET:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return imebra::stringToNSString(((imebra::CMoveCommand*)m_pDimseCommandBase)->getDestinationAET());

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

@end


@implementation ImebraCMoveResponse

-(id)initWithCommand:(ImebraCMoveCommand*)pReceivedCommand
    responseCode:(ImebraDimseStatusCode_t)responseCode
    remainingSubOperations:(unsigned int)remainingSubOperations
    completedSubOperations:(unsigned int)completedSubOperations
    failedSubOperations:(unsigned int)failedSubOperations
    warningSubOperations:(unsigned int)warningSubOperations
    identifier:(ImebraDataSet*)pIdentifier
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::CMoveResponse(
                    *(imebra::CMoveCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    (imebra::dimseStatusCode_t)responseCode,
                    (std::uint32_t)remainingSubOperations,
                    (std::uint32_t)completedSubOperations,
                    (std::uint32_t)failedSubOperations,
                    (std::uint32_t)warningSubOperations,
                    *(pIdentifier->m_pDataSet));
    }
    return self;

}

-(id)initWithcommand:(ImebraCMoveCommand*)pReceivedCommand
    responseCode:(ImebraDimseStatusCode_t)responseCode
    remainingSubOperations:(unsigned int)remainingSubOperations
    completedSubOperations:(unsigned int)completedSubOperations
    failedSubOperations:(unsigned int)failedSubOperations
    warningSubOperations:(unsigned int)warningSubOperations
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::CMoveResponse(
                    *(imebra::CMoveCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    (imebra::dimseStatusCode_t)responseCode,
                    (std::uint32_t)remainingSubOperations,
                    (std::uint32_t)completedSubOperations,
                    (std::uint32_t)failedSubOperations,
                    (std::uint32_t)warningSubOperations);
    }
    return self;

}


@end


@implementation ImebraCEchoCommand

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    priority:(ImebraDimseCommandPriority_t)priority
    affectedSopClassUid:(NSString*)affectedSopClassUid
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::CEchoCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    (imebra::dimseCommandPriority_t)priority,
                    imebra::NSStringToString(affectedSopClassUid));
    }
    return self;

}

@end


@implementation ImebraCEchoResponse

-(id)initWithcommand:(ImebraCEchoCommand*)pReceivedCommand
    responseCode:(ImebraDimseStatusCode_t)responseCode
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::CEchoResponse(
                    *(imebra::CEchoCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    (imebra::dimseStatusCode_t)responseCode);
    }
    return self;

}

@end


@implementation ImebraCCancelCommand

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    priority:(ImebraDimseCommandPriority_t)priority
    cancelMessageID:(unsigned short)cancelMessageID
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::CCancelCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    (imebra::dimseCommandPriority_t)priority,
                    (std::uint16_t)cancelMessageID);
    }
    return self;
}

-(unsigned short)cancelMessageID
{
    return (unsigned short)((imebra::CCancelCommand*)m_pDimseCommandBase)->getCancelMessageID();
}

@end


@implementation ImebraNEventReportCommand

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    affectedSopClassUid:(NSString*)affectedSopClassUid
    affectedSopInstanceUid:(NSString*)affectedSopInstanceUid
    eventID:(unsigned short)eventID
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NEventReportCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    imebra::NSStringToString(affectedSopClassUid),
                    imebra::NSStringToString(affectedSopInstanceUid),
                    (std::uint16_t)eventID);
    }
    return self;
}

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    affectedSopClassUid:(NSString*)affectedSopClassUid
    affectedSopInstanceUid:(NSString*)affectedSopInstanceUid
    eventID:(unsigned short)eventID
    eventInformation:(ImebraDataSet*)pEventInformation
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NEventReportCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    imebra::NSStringToString(affectedSopClassUid),
                    imebra::NSStringToString(affectedSopInstanceUid),
                    (std::uint16_t)eventID,
                    *(pEventInformation->m_pDataSet));
    }
    return self;
}

-(unsigned short) eventID
{
    return (unsigned short)((imebra::NEventReportCommand*)m_pDimseCommandBase)->getEventID();
}

@end


@implementation ImebraNEventReportResponse

-(id)initWithCommand:(ImebraNEventReportCommand*)pReceivedCommand
    eventReply:(ImebraDataSet*)pEventReply
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NEventReportResponse(
                    *(imebra::NEventReportCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    *(pEventReply->m_pDataSet));
    }
    return self;

}

-(id)initWithcommand:(ImebraNEventReportCommand*)pReceivedCommand
    responseCode:(ImebraDimseStatusCode_t)responseCode
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NEventReportResponse(
                    *(imebra::NEventReportCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    (imebra::dimseStatusCode_t)responseCode);
    }
    return self;

}

-(unsigned short) eventID
{
    return (unsigned short)((imebra::NEventReportResponse*)m_pDimseCommandBase)->getEventID();
}

@end


@implementation ImebraNGetCommand

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    requestedSopClassUid:(NSString*)requestedSopClassUid
    requestedSopInstanceUid:(NSString*)requestedSopInstanceUid
    attributeIdentifierList:(NSArray*)pAttributeIdentifierList
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        imebra::attributeIdentifierList_t identifierList;
        size_t identifiersCount = [pAttributeIdentifierList count];
        for(unsigned int scanIdentifiers(0); scanIdentifiers != identifiersCount; ++scanIdentifiers)
        {
            unsigned int group = ((ImebraTagId*)[pAttributeIdentifierList objectAtIndex:scanIdentifiers]).groupId;
            unsigned int tag = ((ImebraTagId*)[pAttributeIdentifierList objectAtIndex:scanIdentifiers]).tagId;
            identifierList.push_back((imebra::tagId_t)((group << 16) | tag));
        }

        m_pDimseCommandBase = new imebra::NGetCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    imebra::NSStringToString(requestedSopClassUid),
                    imebra::NSStringToString(requestedSopInstanceUid),
                    identifierList);
    }
    return self;

}

-(NSArray*) attributeList
{
    imebra::attributeIdentifierList_t identifiersList(((imebra::NGetCommand*)m_pDimseCommandBase)->getAttributeList());

    NSMutableArray* pIdentifiers = [[NSMutableArray alloc] init];

    for(const imebra::tagId_t tagId: identifiersList)
    {
        [pIdentifiers addObject: [[ImebraTagId alloc] initWithGroup:(unsigned short)((std::uint32_t)tagId >> 16) tag:(unsigned short)((std::uint32_t)tagId & 0xffff)]];
    }

    return pIdentifiers;
}

@end


@implementation ImebraNGetResponse

-(id)initWithCommand:(ImebraNGetCommand*)pReceivedCommand
    responseCode:(ImebraDimseStatusCode_t)responseCode
    attributeList:(ImebraDataSet*)pAttributeList
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NGetResponse(
                    *(imebra::NGetCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    (imebra::dimseStatusCode_t)responseCode,
                    *(pAttributeList->m_pDataSet));
    }
    return self;

}

-(id)initWithcommand:(ImebraNGetCommand*)pReceivedCommand
    responseCode:(ImebraDimseStatusCode_t)responseCode
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NGetResponse(
                    *(imebra::NGetCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    (imebra::dimseStatusCode_t)responseCode);
    }
    return self;
}

@end


@implementation ImebraNSetCommand

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    requestedSopClassUid:(NSString*)requestedSopClassUid
    requestedSopInstanceUid:(NSString*)requestedSopInstanceUid
    modificationList:(ImebraDataSet*)pModificationList
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NSetCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    imebra::NSStringToString(requestedSopClassUid),
                    imebra::NSStringToString(requestedSopInstanceUid),
                    *(pModificationList->m_pDataSet));
    }
    return self;

}

@end


@implementation ImebraNSetResponse

-(id)initWithCommand:(ImebraNSetCommand*)pReceivedCommand
    modifiedAttributes:(NSArray*)pModifiedAttributes
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        imebra::attributeIdentifierList_t identifierList;
        size_t identifiersCount = [pModifiedAttributes count];
        for(unsigned int scanIdentifiers(0); scanIdentifiers != identifiersCount; ++scanIdentifiers)
        {
            unsigned int group = ((ImebraTagId*)[pModifiedAttributes objectAtIndex:scanIdentifiers]).groupId;
            unsigned int tag = ((ImebraTagId*)[pModifiedAttributes objectAtIndex:scanIdentifiers]).tagId;
            identifierList.push_back((imebra::tagId_t)((group << 16) | tag));
        }

        m_pDimseCommandBase = new imebra::NSetResponse(
                    *(imebra::NSetCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    identifierList);
    }
    return self;
}

-(id)initWithcommand:(ImebraNSetCommand*)pReceivedCommand
    responseCode:(ImebraDimseStatusCode_t)responseCode
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NSetResponse(
                    *(imebra::NSetCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    (imebra::dimseStatusCode_t)responseCode);
    }
    return self;
}

-(NSArray*) modifiedAttributes
{
    imebra::attributeIdentifierList_t identifiersList(((imebra::NSetResponse*)m_pDimseCommandBase)->getModifiedAttributes());

    NSMutableArray* pIdentifiers = [[NSMutableArray alloc] init];

    for(const imebra::tagId_t tagId: identifiersList)
    {
        [pIdentifiers addObject: [[ImebraTagId alloc] initWithGroup:(unsigned short)((std::uint32_t)tagId >> 16) tag:(unsigned short)((std::uint32_t)tagId & 0xffff)]];
    }

    return pIdentifiers;

}

@end



@implementation ImebraNActionCommand

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    requestedSopClassUid:(NSString*)requestedSopClassUid
    requestedSopInstanceUid:(NSString*)requestedSopInstanceUid
    actionID:(unsigned short)actionID
    actionInformation:(ImebraDataSet*)pActionInformation
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NActionCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    imebra::NSStringToString(requestedSopClassUid),
                    imebra::NSStringToString(requestedSopInstanceUid),
                    (std::uint16_t)actionID,
                    *(pActionInformation->m_pDataSet));
    }
    return self;

}

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    requestedSopClassUid:(NSString*)requestedSopClassUid
    requestedSopInstanceUid:(NSString*)requestedSopInstanceUid
    actionID:(unsigned short)actionID
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NActionCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    imebra::NSStringToString(requestedSopClassUid),
                    imebra::NSStringToString(requestedSopInstanceUid),
                    (std::uint16_t)actionID);
    }
    return self;

}

-(unsigned short) actionID
{
    return (unsigned short)((imebra::NActionCommand*)m_pDimseCommandBase)->getActionID();
}

@end


@implementation ImebraNActionResponse

-(id)initWithCommand:(ImebraNActionCommand*)pReceivedCommand
    actionReply:(ImebraDataSet*)pActionReply
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NActionResponse(
                    *(imebra::NActionCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    *(pActionReply->m_pDataSet));
    }
    return self;

}

-(id)initWithcommand:(ImebraNActionCommand*)pReceivedCommand
    responseCode:(ImebraDimseStatusCode_t)responseCode
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NActionResponse(
                    *(imebra::NActionCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    (imebra::dimseStatusCode_t)responseCode);
    }
    return self;

}

-(unsigned short) actionID
{
    return (unsigned short)((imebra::NActionResponse*)m_pDimseCommandBase)->getActionID();
}

@end


@implementation ImebraNCreateCommand

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    affectedSopClassUid:(NSString*)affectedSopClassUid
    affectedSopInstanceUid:(NSString*)affectedSopInstanceUid
    attributeList:(ImebraDataSet*)pAttributeList
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NCreateCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    imebra::NSStringToString(affectedSopClassUid),
                    imebra::NSStringToString(affectedSopInstanceUid),
                    *(pAttributeList->m_pDataSet));
    }
    return self;
}

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    affectedSopClassUid:(NSString*)affectedSopClassUid
    affectedSopInstanceUid:(NSString*)affectedSopInstanceUid
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NCreateCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    imebra::NSStringToString(affectedSopClassUid),
                    imebra::NSStringToString(affectedSopInstanceUid));
    }
    return self;
}

@end


@implementation ImebraNCreateResponse

-(id)initWithCommand:(ImebraNCreateCommand*)pReceivedCommand
    attributeList:(ImebraDataSet*)pAttributeList
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NCreateResponse(
                    *(imebra::NCreateCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    *(pAttributeList->m_pDataSet));
    }
    return self;

}

-(id)initWithCommand:(ImebraNCreateCommand*)pReceivedCommand
    affectedSopInstanceUid:(NSString*)affectedSopInstanceUid
    attributeList:(ImebraDataSet*)pAttributeList
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NCreateResponse(
                    *(imebra::NCreateCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    imebra::NSStringToString(affectedSopInstanceUid),
                    *(pAttributeList->m_pDataSet));
    }
    return self;

}

-(id)initWithCommand:(ImebraNCreateCommand*)pReceivedCommand
    affectedSopInstanceUid:(NSString*)affectedSopInstanceUid
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NCreateResponse(
                    *(imebra::NCreateCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    imebra::NSStringToString(affectedSopInstanceUid));
    }
    return self;

}

-(id)initWithcommand:(ImebraNCreateCommand*)pReceivedCommand
    responseCode:(ImebraDimseStatusCode_t)responseCode
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NCreateResponse(
                    *(imebra::NCreateCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    (imebra::dimseStatusCode_t)responseCode);
    }
    return self;

}

@end


@implementation ImebraNDeleteCommand

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
    messageID:(unsigned short)messageID
    requestedSopClassUid:(NSString*)requestedSopClassUid
    requestedSopInstanceUid:(NSString*)requestedSopInstanceUid
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NDeleteCommand(
                    imebra::NSStringToString(abstractSyntax),
                    (std::uint16_t)messageID,
                    imebra::NSStringToString(requestedSopClassUid),
                    imebra::NSStringToString(requestedSopInstanceUid));
    }
    return self;

}

@end


@implementation ImebraNDeleteResponse

-(id)initWithcommand:(ImebraNDeleteCommand*)pReceivedCommand
    responseCode:(ImebraDimseStatusCode_t)responseCode
{
    m_pDimseCommandBase = 0;
    self = [super init];
    if(self)
    {
        m_pDimseCommandBase = new imebra::NDeleteResponse(
                    *(imebra::NDeleteCommand*)(pReceivedCommand->m_pDimseCommandBase),
                    (imebra::dimseStatusCode_t)responseCode);
    }
    return self;
}

@end


@implementation ImebraDimseService

-(id)initWithAssociation:(ImebraAssociationBase*)pAssociation
{
    m_pDimseService = 0;
    self = [super init];
    if(self)
    {
        m_pDimseService = new imebra::DimseService(*(pAssociation->m_pAssociation));
    }
    return self;
}

-(void)dealloc
{
    delete m_pDimseService;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif

}

-(NSString*)getTransferSyntax:(NSString*)abstractSyntax error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return imebra::stringToNSString(m_pDimseService->getTransferSyntax(imebra::NSStringToString(abstractSyntax)));

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(unsigned short)getNextCommandID
{
    return (unsigned short)m_pDimseService->getNextCommandID();
}

-(ImebraDimseCommand*)getCommand:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::DimseCommand> pCommand(m_pDimseService->getCommand());

    switch(pCommand->getCommandType())
    {
    case imebra::dimseCommandType_t::cStore:
        return [[ImebraCStoreCommand alloc] initWithImebraCommand:pCommand.release()];
    case imebra::dimseCommandType_t::cGet:
        return [[ImebraCGetCommand alloc] initWithImebraCommand:pCommand.release()];
    case imebra::dimseCommandType_t::cMove:
        return [[ImebraCMoveCommand alloc] initWithImebraCommand:pCommand.release()];
    case imebra::dimseCommandType_t::cFind:
        return [[ImebraCFindCommand alloc] initWithImebraCommand:pCommand.release()];
    case imebra::dimseCommandType_t::cEcho:
        return [[ImebraCEchoCommand alloc] initWithImebraCommand:pCommand.release()];
    case imebra::dimseCommandType_t::cCancel:
        return [[ImebraCCancelCommand alloc] initWithImebraCommand:pCommand.release()];
    case imebra::dimseCommandType_t::nEventReport:
        return [[ImebraNEventReportCommand alloc] initWithImebraCommand:pCommand.release()];
    case imebra::dimseCommandType_t::nGet:
        return [[ImebraNGetCommand alloc] initWithImebraCommand:pCommand.release()];
    case imebra::dimseCommandType_t::nSet:
        return [[ImebraNSetCommand alloc] initWithImebraCommand:pCommand.release()];
    case imebra::dimseCommandType_t::nAction:
        return [[ImebraNActionCommand alloc] initWithImebraCommand:pCommand.release()];
    case imebra::dimseCommandType_t::nCreate:
        return [[ImebraNCreateCommand alloc] initWithImebraCommand:pCommand.release()];
    case imebra::dimseCommandType_t::nDelete:
        return [[ImebraNDeleteCommand alloc] initWithImebraCommand:pCommand.release()];
    default:
        break;
    }

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(void)sendCommandOrResponse:(ImebraDimseCommandBase*)pCommand error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    m_pDimseService->sendCommandOrResponse(*(pCommand->m_pDimseCommandBase));

    OBJC_IMEBRA_FUNCTION_END();
}

-(ImebraCStoreResponse*)getCStoreResponse:(ImebraCStoreCommand*)pCommand error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::CStoreResponse> pResponse(m_pDimseService->getCStoreResponse(*(imebra::CStoreCommand*)(pCommand->m_pDimseCommandBase)));
    return [[ImebraCStoreResponse alloc] initWithImebraCommand:pResponse.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraCGetResponse*)getCGetResponse:(ImebraCGetCommand*)pCommand error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::CGetResponse> pResponse(m_pDimseService->getCGetResponse(*(imebra::CGetCommand*)(pCommand->m_pDimseCommandBase)));
    return [[ImebraCGetResponse alloc] initWithImebraCommand:pResponse.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraCFindResponse*)getCFindResponse:(ImebraCFindCommand*)pCommand error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::CFindResponse> pResponse(m_pDimseService->getCFindResponse(*(imebra::CFindCommand*)(pCommand->m_pDimseCommandBase)));
    return [[ImebraCFindResponse alloc] initWithImebraCommand:pResponse.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraCMoveResponse*)getCMoveResponse:(ImebraCMoveCommand*)pCommand error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::CMoveResponse> pResponse(m_pDimseService->getCMoveResponse(*(imebra::CMoveCommand*)(pCommand->m_pDimseCommandBase)));
    return [[ImebraCMoveResponse alloc] initWithImebraCommand:pResponse.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraCEchoResponse*)getCEchoResponse:(ImebraCEchoCommand*)pCommand error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::CEchoResponse> pResponse(m_pDimseService->getCEchoResponse(*(imebra::CEchoCommand*)(pCommand->m_pDimseCommandBase)));
    return [[ImebraCEchoResponse alloc] initWithImebraCommand:pResponse.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraNEventReportResponse*)getNEventReportResponse:(ImebraNEventReportCommand*)pCommand error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::NEventReportResponse> pResponse(m_pDimseService->getNEventReportResponse(*(imebra::NEventReportCommand*)(pCommand->m_pDimseCommandBase)));
    return [[ImebraNEventReportResponse alloc] initWithImebraCommand:pResponse.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraNGetResponse*)getNGetResponse:(ImebraNGetCommand*)pCommand error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::NGetResponse> pResponse(m_pDimseService->getNGetResponse(*(imebra::NGetCommand*)(pCommand->m_pDimseCommandBase)));
    return [[ImebraNGetResponse alloc] initWithImebraCommand:pResponse.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraNSetResponse*)getNSetResponse:(ImebraNSetCommand*)pCommand error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::NSetResponse> pResponse(m_pDimseService->getNSetResponse(*(imebra::NSetCommand*)(pCommand->m_pDimseCommandBase)));
    return [[ImebraNSetResponse alloc] initWithImebraCommand:pResponse.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraNActionResponse*)getNActionResponse:(ImebraNActionCommand*)pCommand error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::NActionResponse> pResponse(m_pDimseService->getNActionResponse(*(imebra::NActionCommand*)(pCommand->m_pDimseCommandBase)));
    return [[ImebraNActionResponse alloc] initWithImebraCommand:pResponse.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraNCreateResponse*)getNCreateResponse:(ImebraNCreateCommand*)pCommand error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::NCreateResponse> pResponse(m_pDimseService->getNCreateResponse(*(imebra::NCreateCommand*)(pCommand->m_pDimseCommandBase)));
    return [[ImebraNCreateResponse alloc] initWithImebraCommand:pResponse.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraNDeleteResponse*)getNDeleteResponse:(ImebraNDeleteCommand*)pCommand error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::NDeleteResponse> pResponse(m_pDimseService->getNDeleteResponse(*(imebra::NDeleteCommand*)(pCommand->m_pDimseCommandBase)));
    return [[ImebraNDeleteResponse alloc] initWithImebraCommand:pResponse.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

@end

