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

@implementation ImebraPipe

-(id)initWithBufferSize:(unsigned int)circularBufferSize
{
    self =  [super init];
    if(self)
    {
        m_pBaseStreamInput = new imebra::Pipe((size_t)circularBufferSize);
    }
    return self;
}

-(void) feed:(ImebraReadMemory*)buffer error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    ((imebra::Pipe*)m_pBaseStreamInput)->feed(*(buffer->m_pMemory));

    OBJC_IMEBRA_FUNCTION_END();
}

-(unsigned int) sink:(ImebraReadWriteMemory*)buffer error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return (unsigned int)((imebra::Pipe*)m_pBaseStreamInput)->sink(*(imebra::ReadWriteMemory*)(buffer->m_pMemory));

    OBJC_IMEBRA_FUNCTION_END_RETURN(0);
}

-(void) close: (unsigned int) timeoutMilliseconds error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    ((imebra::Pipe*)m_pBaseStreamInput)->close(timeoutMilliseconds);

    OBJC_IMEBRA_FUNCTION_END();
}

-(void) terminate
{
    ((imebra::Pipe*)m_pBaseStreamInput)->terminate();
}

@end
