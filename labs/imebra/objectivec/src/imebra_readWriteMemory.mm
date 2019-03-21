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

@implementation ImebraReadWriteMemory

-(id)initWithImebraReadWriteMemory:(imebra::ReadWriteMemory*)pReadWriteMemory
{
    return [super initWithImebraReadMemory:pReadWriteMemory];
}

-(id)init
{
    return [super initWithImebraReadMemory:new imebra::ReadWriteMemory()];
}

-(id)initWithSize:(unsigned int)size
{
    return [super initWithImebraReadMemory:new imebra::ReadWriteMemory((size_t)size)];
}

-(id)initWithMemory:(ImebraReadMemory*)source
{
    return [super initWithImebraReadMemory:(new imebra::ReadWriteMemory(*(source->m_pMemory)))];
}

-(id)initWithData:(NSData*)pSource
{
    self = [super init];
    if(self)
    {
        self->m_pMemory = new imebra::ReadWriteMemory((char*)pSource.bytes, (size_t)pSource.length);
    }
    return self;
}

-(void)dealloc
{
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(void)copyFrom:(ImebraReadMemory*)source error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    ((imebra::ReadWriteMemory*)m_pMemory)->copyFrom(*(source->m_pMemory));

    OBJC_IMEBRA_FUNCTION_END();
}

-(void)clear:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    ((imebra::ReadWriteMemory*)m_pMemory)->clear();

    OBJC_IMEBRA_FUNCTION_END();
}

-(void)resize:(unsigned int)newSize error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    ((imebra::ReadWriteMemory*)m_pMemory)->resize((size_t)newSize);

    OBJC_IMEBRA_FUNCTION_END();
}

-(void)reserve:(unsigned int)reserveSize error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    ((imebra::ReadWriteMemory*)m_pMemory)->reserve((size_t)reserveSize);

    OBJC_IMEBRA_FUNCTION_END();
}

-(void)assign:(NSData*)pSource error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    ((imebra::ReadWriteMemory*)m_pMemory)->assign((char*)pSource.bytes, (size_t)pSource.length);

    OBJC_IMEBRA_FUNCTION_END();
}

-(void)assignRegion:(NSData*)pSource offset:(unsigned int)destinationOffset error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    ((imebra::ReadWriteMemory*)m_pMemory)->assignRegion((char*)pSource.bytes, (size_t)pSource.length, (size_t)destinationOffset);

    OBJC_IMEBRA_FUNCTION_END();
}

@end
