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

@implementation ImebraReadingDataHandlerNumeric

-(ImebraReadMemory*)getMemory:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraReadMemory alloc] initWithImebraReadMemory:((imebra::ReadingDataHandlerNumeric*)m_pReadingDataHandler)->getMemory()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(void)copyTo:(ImebraWritingDataHandlerNumeric*)destination error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    ((imebra::ReadingDataHandlerNumeric*)m_pReadingDataHandler)->copyTo(*((imebra::WritingDataHandlerNumeric*)destination->m_pWritingDataHandlerVoidPointer));

    OBJC_IMEBRA_FUNCTION_END();
}

-(unsigned int) unitSize
{
    return (unsigned int)((imebra::ReadingDataHandlerNumeric*)m_pReadingDataHandler)->getUnitSize();
}

-(bool) isSigned
{
    return ((imebra::ReadingDataHandlerNumeric*)m_pReadingDataHandler)->isSigned();
}

-(bool) isFloat
{
    return ((imebra::ReadingDataHandlerNumeric*)m_pReadingDataHandler)->isFloat();
}

@end
