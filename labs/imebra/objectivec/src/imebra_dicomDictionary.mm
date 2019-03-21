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


@class ImebraTagId;

@implementation ImebraDicomDictionary

+(NSString*)getTagName:(ImebraTagId*)tagId error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return imebra::stringToNSString(imebra::DicomDictionary::getTagName(*(tagId->m_pTagId)));

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

+(ImebraTagVR_t)getTagType:(ImebraTagId*)tagId error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return (ImebraTagVR_t)(imebra::DicomDictionary::getTagType(*(tagId->m_pTagId)));

    OBJC_IMEBRA_FUNCTION_END_RETURN(ImebraAE);
}

+(unsigned int)getWordSize:(ImebraTagVR_t)dataType
{
    return (unsigned int)imebra::DicomDictionary::getWordSize((imebra::tagVR_t)dataType);
}

+(unsigned int)getMaxSize:(ImebraTagVR_t)dataType
{
    return (unsigned int)imebra::DicomDictionary::getMaxSize((imebra::tagVR_t)dataType);
}

@end
