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

@implementation ImebraImage

-(id)initWithImebraImage:(imebra::Image*)pImage
{
    m_pImage = 0;
    self =  [super init];
    if(self)
    {
        m_pImage = pImage;
    }
    else
    {
        delete pImage;
    }
    return self;
}

-(id)initWithWidth:(unsigned int)width height:(unsigned int)height depth:(ImebraBitDepth_t)depth colorSpace:(NSString*)colorSpace highBit:(unsigned int)highBit
{
    self =  [super init];
    if(self)
    {
        m_pImage = new imebra::Image(
                                 width,
                                 height,
                                 (imebra::bitDepth_t)depth,
                                 imebra::NSStringToString(colorSpace),
                                 highBit);
    }
    return self;
}

///
/// \ Destructor
///
///////////////////////////////////////////////////////////////////////////////
-(void)dealloc
{
    delete m_pImage;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(ImebraReadingDataHandlerNumeric*) getReadingDataHandler:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraReadingDataHandlerNumeric alloc] initWithImebraReadingDataHandler:m_pImage->getReadingDataHandler()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraWritingDataHandlerNumeric*) getWritingDataHandler:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraWritingDataHandlerNumeric alloc] initWithImebraWritingDataHandler:m_pImage->getWritingDataHandler()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(double) widthMm
{
    return m_pImage->getWidthMm();
}

-(double) heightMm
{
    return m_pImage->getHeightMm();
}

-(void) setWidthMm:(double)width
{
    m_pImage->setSizeMm(width, m_pImage->getHeightMm());
}

-(void) setHeightMm:(double)height
{
    m_pImage->setSizeMm(m_pImage->getWidthMm(), height);
}

-(unsigned int) width
{
    return m_pImage->getWidth();
}

-(unsigned int) height
{
    return m_pImage->getHeight();
}

-(NSString*) colorSpace
{
    return imebra::stringToNSString(m_pImage->getColorSpace());
}

-(unsigned int) getChannelsNumber
{
    return m_pImage->getChannelsNumber();
}

-(ImebraBitDepth_t) getDepth
{
    return (ImebraBitDepth_t)m_pImage->getDepth();
}

-(unsigned int) getHighBit
{
    return m_pImage->getHighBit();
}

@end

