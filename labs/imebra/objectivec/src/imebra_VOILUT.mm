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

@implementation ImebraVOILUT

-(id)init
{
    m_pTransform = 0;
    self = [super init];
    if(self)
    {
        m_pTransform = new imebra::VOILUT();
    }
    return self;
}

-(void)applyOptimalVOI:
    (ImebraImage*)pInputImage
    inputTopLeftX:(unsigned int)inputTopLeftX
    inputTopLeftY:(unsigned int)inputTopLeftY
    inputWidth:(unsigned int)inputWidth
    inputHeight:(unsigned int)inputHeight
    error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    ((imebra::VOILUT*)m_pTransform)->applyOptimalVOI(
                *(pInputImage->m_pImage),
                (std::uint32_t)inputTopLeftX,
                (std::uint32_t)inputTopLeftY,
                (std::uint32_t)inputWidth,
                (std::uint32_t)inputHeight);

    OBJC_IMEBRA_FUNCTION_END();
}

-(void)setCenter:(double)center width:(double)width
{
    ((imebra::VOILUT*)m_pTransform)->setCenterWidth(center, width);
}

-(void)setLUT:(ImebraLUT*)pLUT
{
    ((imebra::VOILUT*)m_pTransform)->setLUT(*(pLUT->m_pLUT));
}

-(double) center
{
    return ((imebra::VOILUT*)m_pTransform)->getCenter();
}

-(double) width
{
    return ((imebra::VOILUT*)m_pTransform)->getWidth();
}


@end


