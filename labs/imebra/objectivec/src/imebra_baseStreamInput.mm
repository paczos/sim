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

@implementation ImebraBaseStreamInput

-(void)dealloc
{
    delete m_pBaseStreamInput;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end


@implementation ImebraStreamTimeout

-(id)initWithInputStream:(ImebraBaseStreamInput*)pStream timeoutSeconds:(unsigned int)timeoutSeconds
{
    self = [super init];
    if(self)
    {
        m_pStreamTimeout = new imebra::StreamTimeout(*(pStream->m_pBaseStreamInput), (std::uint32_t)timeoutSeconds);
    }
    return self;
}

-(void)dealloc
{
    delete m_pStreamTimeout;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end


