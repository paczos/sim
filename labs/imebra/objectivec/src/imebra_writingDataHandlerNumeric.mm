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

@implementation ImebraWritingDataHandlerNumeric

-(ImebraReadWriteMemory*)getMemory:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    if(m_pWritingDataHandler != 0)
    {
        return [[ImebraReadWriteMemory alloc] initWithImebraReadWriteMemory:((imebra::WritingDataHandlerNumeric*)m_pWritingDataHandler)->getMemory()];
    }
    else
    {
        return nil;
    }

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(void)assign:(NSData*)pSource error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    if(m_pWritingDataHandler != 0)
    {
        ((imebra::WritingDataHandlerNumeric*)m_pWritingDataHandler)->assign((char*)pSource.bytes, (size_t)pSource.length);
    }

    OBJC_IMEBRA_FUNCTION_END();
}

-(void)copyFrom:(ImebraReadingDataHandlerNumeric*)pSource error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    if(m_pWritingDataHandler != 0)
    {
        ((imebra::WritingDataHandlerNumeric*)m_pWritingDataHandler)->copyFrom(*((imebra::ReadingDataHandlerNumeric*)pSource->m_pReadingDataHandler));
    }

    OBJC_IMEBRA_FUNCTION_END();
}

-(unsigned int) unitSize
{
    if(m_pWritingDataHandler != 0)
    {
        return (unsigned int)((imebra::WritingDataHandlerNumeric*)m_pWritingDataHandler)->getUnitSize();
    }
    else
    {
        return 0;
    }
}

-(bool) isSigned
{
    if(m_pWritingDataHandler != 0)
    {
        return ((imebra::WritingDataHandlerNumeric*)m_pWritingDataHandler)->isSigned();
    }
    else
    {
        return false;
    }
}

-(bool) isFloat
{
    if(m_pWritingDataHandler != 0)
    {
        return ((imebra::WritingDataHandlerNumeric*)m_pWritingDataHandler)->isFloat();
    }
    else
    {
        return 0;
    }
}

@end
