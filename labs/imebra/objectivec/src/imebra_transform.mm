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

@implementation ImebraTransform


-(id)initWithImebraTransform:(imebra::Transform*)pTransform
{
    m_pTransform = 0;
    self = [super init];
    if(self)
    {
        m_pTransform = pTransform;
    }
    else
    {
        delete pTransform;
    }
    return self;
}


-(void)dealloc
{
    delete m_pTransform;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


-(ImebraImage*) allocateOutputImage:
    (ImebraImage*)pInputImage
    width:(unsigned int)width
    height:(unsigned int)height
    error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraImage alloc] initWithImebraImage:m_pTransform->allocateOutputImage(*(pInputImage->m_pImage), (std::uint32_t)width, (std::uint32_t)height)];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


-(void) runTransform:
    (ImebraImage*)pInputImage
    inputTopLeftX:(unsigned int)inputTopLeftX
    inputTopLeftY:(unsigned int)inputTopLeftY
    inputWidth:(unsigned int)inputWidth
    inputHeight:(unsigned int)inputHeight
    outputImage:(ImebraImage*)pOutputImage
    outputTopLeftX:(unsigned int)outputTopLeftX
    outputTopLeftY:(unsigned int)outputTopLeftY
    error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    m_pTransform->runTransform(*(pInputImage->m_pImage),
                               (std::uint32_t)inputTopLeftX,
                               (std::uint32_t)inputTopLeftY,
                               (std::uint32_t)inputWidth,
                               (std::uint32_t)inputHeight,
                               *(pOutputImage->m_pImage),
                               (std::uint32_t)outputTopLeftX,
                               (std::uint32_t)outputTopLeftY);

    OBJC_IMEBRA_FUNCTION_END();
}

-(BOOL)isEmpty
{
    return (BOOL)(m_pTransform->isEmpty());
}

@end


