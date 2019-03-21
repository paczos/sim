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

void CGDataProviderCallbackFunc(void *info, const void* /* data */, size_t /* size */)
{
    // Release the shared pointer holding the memory
    ////////////////////////////////////////////////
    delete (imebra::ReadWriteMemory*)info;
}


@implementation ImebraDrawBitmap

-(id)init
{
    m_pDrawBitmap = 0;
    self = [super init];
    if(self)
    {
        m_pDrawBitmap = new imebra::DrawBitmap();
    }
    return self;
}

-(id)initWithTransform:(ImebraTransform*)pTransform
{
    m_pDrawBitmap = 0;
    self = [super init];
    if(self)
    {
        m_pDrawBitmap = new imebra::DrawBitmap(*(pTransform->m_pTransform));
    }
    return self;
}

-(void)dealloc
{
    delete m_pDrawBitmap;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif

}


-(ImebraReadWriteMemory*) getBitmap:(ImebraImage*)pImage bitmapType:(ImebraDrawBitmapType_t)drawBitmapType rowAlignBytes:(unsigned int)rowAlignBytes error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraReadWriteMemory alloc] initWithImebraReadWriteMemory:m_pDrawBitmap->getBitmap(*(pImage->m_pImage), (imebra::drawBitmapType_t)drawBitmapType, (std::uint32_t)rowAlignBytes)];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


#if defined(__APPLE__)

#if TARGET_OS_IPHONE
-(UIImage*)getImebraImage:(ImebraImage*)pImage error:(NSError**)pError
#else
-(NSImage*)getImebraImage:(ImebraImage*)pImage error:(NSError**)pError
#endif
{
    OBJC_IMEBRA_FUNCTION_START();

    // Get the amount of memory needed for the conversion
    /////////////////////////////////////////////////////
    std::uint32_t width(pImage->m_pImage->getWidth());
    std::uint32_t height(pImage->m_pImage->getHeight());

    // Get the result raw data
    //////////////////////////
    std::unique_ptr<imebra::ReadWriteMemory> pMemory(m_pDrawBitmap->getBitmap(*(pImage->m_pImage), imebra::drawBitmapType_t::drawBitmapRGBA, 4));
    size_t dataSize;
    char* pData = pMemory->data(&dataSize);

    // Create a CGImage, then convert it to NSImage or UIImage
    //////////////////////////////////////////////////////////
    CGDataProviderRef dataProviderRef = CGDataProviderCreateWithData(pMemory.release(),
                                                                pData,
                                                                dataSize,
                                                                CGDataProviderCallbackFunc);

    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;

    CGImageRef imageRef = CGImageCreate(
                width, height,
                8, 32,
                width * 4,
                colorSpaceRef, bitmapInfo, dataProviderRef, NULL, YES, renderingIntent);


#if TARGET_OS_IPHONE
    UIImage* returnImage = [[UIImage alloc] initWithCGImage:imageRef];
#else
    NSImage* returnImage = [[NSImage alloc] initWithCGImage:imageRef size:NSZeroSize];
#endif
    CGDataProviderRelease(dataProviderRef);
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    return returnImage;

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

#endif

@end
