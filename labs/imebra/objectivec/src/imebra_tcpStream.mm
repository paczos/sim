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

@implementation ImebraTCPStream

-(id)initWithImebraTcpStream:(imebra::TCPStream*)pTcpStream
{
    self = [super init];
    if(self)
    {
        m_pBaseStreamInput = pTcpStream;
    }
    else
    {
        delete pTcpStream;
    }
    return self;

}


-(id)initWithAddress:(ImebraTCPActiveAddress*)pAddress error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    self = [super init];
    if(self)
    {
        m_pBaseStreamInput = new imebra::TCPStream(*(imebra::TCPActiveAddress*)(pAddress->m_pTcpAddress));
    }
    return self;

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


-(ImebraTCPAddress*) getPeerAddress: (NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraTCPAddress alloc] initWithImebraTCPAddress:((imebra::TCPStream*)m_pBaseStreamInput)->getPeerAddress()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


-(void) terminate
{
    ((imebra::TCPStream*)m_pBaseStreamInput)->terminate();
}


@end


