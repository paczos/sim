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

@implementation ImebraTCPListener

-(id)initWithAddress:(ImebraTCPPassiveAddress*)pAddress error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    self = [super init];
    if(self)
    {
        m_pTcpListener = new imebra::TCPListener(*(imebra::TCPPassiveAddress*)(pAddress->m_pTcpAddress));
    }
    return self;

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(void)dealloc
{
    delete m_pTcpListener;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(ImebraTCPStream*)waitForConnection:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraTCPStream alloc] initWithImebraTcpStream:m_pTcpListener->waitForConnection()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(void)terminate
{
    m_pTcpListener->terminate();
}

@end


