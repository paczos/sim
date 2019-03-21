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


@implementation ImebraColorTransformsFactory

+(NSString*) normalizeColorSpace:(NSString*)colorSpace
{
    return imebra::stringToNSString(imebra::ColorTransformsFactory::normalizeColorSpace(imebra::NSStringToString(colorSpace)));
}


+(BOOL)isMonochrome:(NSString*)colorSpace
{
    return (BOOL)imebra::ColorTransformsFactory::isMonochrome(imebra::NSStringToString(colorSpace));
}


+(BOOL)isSubsampledX:(NSString*)colorSpace
{
    return (BOOL)imebra::ColorTransformsFactory::isSubsampledX(imebra::NSStringToString(colorSpace));
}


+(BOOL)isSubsampledY:(NSString*)colorSpace
{
    return (BOOL)imebra::ColorTransformsFactory::isSubsampledY(imebra::NSStringToString(colorSpace));
}


+(BOOL)canSubsample:(NSString*)colorSpace
{
    return (BOOL)imebra::ColorTransformsFactory::canSubsample(imebra::NSStringToString(colorSpace));
}


+(NSString*)makeSubsampled:(NSString*)colorSpace subSampleX:(BOOL)bSubSampleX subSampleY:(BOOL)bSubSampleY
{
    return imebra::stringToNSString(imebra::ColorTransformsFactory::makeSubsampled(imebra::NSStringToString(colorSpace), bSubSampleX != 0, bSubSampleY != 0));
}


+(unsigned int)getNumberOfChannels:(NSString*)colorSpace
{
    return (unsigned int)imebra::ColorTransformsFactory::getNumberOfChannels(imebra::NSStringToString(colorSpace));
}


+(ImebraTransform*)getTransform:(NSString*)startColorSpace finalColorSpace:(NSString*)endColorSpace error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraTransform alloc] initWithImebraTransform: imebra::ColorTransformsFactory::getTransform(imebra::NSStringToString(startColorSpace), imebra::NSStringToString(endColorSpace))];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

@end

