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

@implementation ImebraPresentationContext

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
{
    m_pPresentationContext = 0;
    self = [super init];
    if(self)
    {
        m_pPresentationContext = new imebra::PresentationContext(imebra::NSStringToString(abstractSyntax));
    }
    return self;
}

-(id)initWithAbstractSyntax:(NSString*)abstractSyntax scuRole:(BOOL)bSCURole scpRole:(BOOL)bSCPRole
{
    m_pPresentationContext = 0;
    self = [super init];
    if(self)
    {
        m_pPresentationContext = new imebra::PresentationContext(imebra::NSStringToString(abstractSyntax), bSCURole != 0, bSCPRole != 0);
    }
    return self;
}

-(void)dealloc
{
    delete m_pPresentationContext;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(void)addTransferSyntax:(NSString*)transferSyntax
{
    m_pPresentationContext->addTransferSyntax(imebra::NSStringToString(transferSyntax));
}

@end


@implementation ImebraPresentationContexts

-(id)init
{
    m_pPresentationContexts = 0;
    self = [super init];
    if(self)
    {
        m_pPresentationContexts = new imebra::PresentationContexts();
    }
    return self;

}

-(void)dealloc
{
    delete m_pPresentationContexts;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(void)addPresentationContext:(ImebraPresentationContext*)pPresentationContext
{
    m_pPresentationContexts->addPresentationContext(*(pPresentationContext->m_pPresentationContext));
}

@end


@implementation ImebraAssociationMessage: NSObject

-(id)initWithImebraAssociationMessage:(imebra::AssociationMessage*)pAssociationMessage
{
    m_pAssociationMessage = 0;
    self = [super init];
    if(self)
    {
        m_pAssociationMessage = pAssociationMessage;
    }
    else
    {
        delete pAssociationMessage;
    }
    return self;
}


-(id)initWithAbstractSyntax:(NSString*)abstractSyntax
{
    m_pAssociationMessage = 0;
    self = [super init];
    if(self)
    {
        m_pAssociationMessage = new imebra::AssociationMessage(imebra::NSStringToString(abstractSyntax));
    }
    return self;
}

-(void)dealloc
{
    delete m_pAssociationMessage;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif

}

-(NSString*)abstractSyntax
{
    return imebra::stringToNSString(m_pAssociationMessage->getAbstractSyntax());
}

-(ImebraDataSet*)getCommand:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraDataSet alloc] initWithImebraDataSet:(m_pAssociationMessage->getCommand())];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraDataSet*)getPayload:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraDataSet alloc] initWithImebraDataSet:(m_pAssociationMessage->getPayload())];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(BOOL)hasPayload
{
    return m_pAssociationMessage->hasPayload();
}

-(void)addDataSet:(ImebraDataSet*)pDataSet error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    m_pAssociationMessage->addDataSet(*(pDataSet->m_pDataSet));

    OBJC_IMEBRA_FUNCTION_END();
}

@end


@implementation ImebraAssociationBase

-(void)dealloc
{
    delete m_pAssociation;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(ImebraAssociationMessage*)getCommand:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraAssociationMessage alloc] initWithImebraAssociationMessage:m_pAssociation->getCommand()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraAssociationMessage*)getResponse:(unsigned int) messageId error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();
    return [[ImebraAssociationMessage alloc] initWithImebraAssociationMessage:m_pAssociation->getResponse((std::uint16_t)messageId)];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(void)sendMessage:(ImebraAssociationMessage*)pMessage error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    m_pAssociation->sendMessage(*(pMessage->m_pAssociationMessage));

    OBJC_IMEBRA_FUNCTION_END();
}

-(void)release:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    m_pAssociation->release();

    OBJC_IMEBRA_FUNCTION_END();
}

-(void)abort:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    m_pAssociation->abort();

    OBJC_IMEBRA_FUNCTION_END();
}

-(NSString*)getTransferSyntax:(NSString*)abstractSyntax error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return imebra::stringToNSString(m_pAssociation->getTransferSyntax(imebra::NSStringToString(abstractSyntax)));

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(NSString*)thisAET
{
    return imebra::stringToNSString(m_pAssociation->getThisAET());
}

-(NSString*)otherAET
{
    return imebra::stringToNSString(m_pAssociation->getOtherAET());
}

@end


@implementation ImebraAssociationSCU

-(id)initWithThisAET:(NSString*)thisAET otherAET:(NSString*)otherAET
    maxInvokedOperations:(unsigned int)invokedOperations
    maxPerformedOperations:(unsigned int)performedOperations
    presentationContexts:(ImebraPresentationContexts*)presentationContexts
    reader:(ImebraStreamReader*)pInput
    writer:(ImebraStreamWriter*)pOutput
    dimseTimeoutSeconds:(unsigned int)dimseTimeoutSeconds error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    m_pAssociation = 0;
    self = [super init];
    if(self)
    {
        m_pAssociation = new imebra::AssociationSCU(
                    imebra::NSStringToString(thisAET),
                    imebra::NSStringToString(otherAET),
                    invokedOperations,
                    performedOperations,
                    *(presentationContexts->m_pPresentationContexts),
                    *(pInput->m_pReader),
                    *(pOutput->m_pWriter),
                    dimseTimeoutSeconds);
    }
    return self;

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

@end


@implementation ImebraAssociationSCP

-(id)initWithThisAET:(NSString*)thisAET
    maxInvokedOperations:(unsigned int)invokedOperations
    maxPerformedOperations:(unsigned int)performedOperations
    presentationContexts:(ImebraPresentationContexts*)presentationContexts
    reader:(ImebraStreamReader*)pInput
    writer:(ImebraStreamWriter*)pOutput
    dimseTimeoutSeconds:(unsigned int)dimseTimeoutSeconds
    artimTimeoutSeconds:(unsigned int)artimTimeoutSeconds error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    m_pAssociation = 0;
    self = [super init];
    if(self)
    {
        m_pAssociation = new imebra::AssociationSCP(
                    imebra::NSStringToString(thisAET),
                    invokedOperations,
                    performedOperations,
                    *(presentationContexts->m_pPresentationContexts),
                    *(pInput->m_pReader),
                    *(pOutput->m_pWriter),
                    dimseTimeoutSeconds,
                    artimTimeoutSeconds);
    }
    return self;

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

@end


