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

@implementation ImebraTCPAddress

-(id)initWithImebraTCPAddress:(imebra::TCPAddress*)pTcpAddress
{
    self = [super init];
    if(self)
    {
        m_pTcpAddress = pTcpAddress;
    }
    else
    {
        delete pTcpAddress;
    }
    return self;

}


-(void)dealloc
{
    delete m_pTcpAddress;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(NSString*) node
{
    return imebra::stringToNSString(m_pTcpAddress->getNode());
}

-(NSString*) service
{
    return imebra::stringToNSString(m_pTcpAddress->getService());
}

@end


@implementation ImebraTCPActiveAddress

-(id)initWithNode:(NSString*)node service:(NSString*)service error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    self = [super init];
    if(self)
    {
        m_pTcpAddress = new imebra::TCPActiveAddress(imebra::NSStringToString(node), imebra::NSStringToString(service));
    }
    return self;

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

@end


@implementation ImebraTCPPassiveAddress

-(id)initWithNode:(NSString*)node service:(NSString*)service error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    self = [super init];
    if(self)
    {
        m_pTcpAddress = new imebra::TCPPassiveAddress(imebra::NSStringToString(node), imebra::NSStringToString(service));
    }
    return self;

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

@end

