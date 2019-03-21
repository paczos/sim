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

@implementation ImebraReadMemory

-(id)initWithImebraReadMemory:(imebra::ReadMemory*)pReadMemory
{
    self->m_pMemory = 0;
    self = [super init];
    if(self)
    {
        self->m_pMemory = pReadMemory;
    }
    else
    {
        delete pReadMemory;
    }
    return self;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self->m_pMemory = new imebra::ReadMemory();
    }
    return self;
}


-(id)initWithData:(NSData*)pSource
{
    self = [super init];
    if(self)
    {
        self->m_pMemory = new imebra::ReadMemory((char*)pSource.bytes, (size_t)pSource.length);
    }
    return self;
}

-(void)dealloc
{
    delete self->m_pMemory;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(NSData*)data
{
    size_t dataSize;
    const char* pMemory(m_pMemory->data(&dataSize));
    NSData* pData = [NSData dataWithBytes:pMemory length:dataSize];
    return pData;
}

-(bool)empty
{
    return m_pMemory->empty();

}


@end


