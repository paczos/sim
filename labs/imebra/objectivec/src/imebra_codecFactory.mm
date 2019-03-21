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

@implementation ImebraCodecFactory

+(ImebraDataSet*)loadFromFile:(NSString*) fileName error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::DataSet> pDataSet(imebra::CodecFactory::load(imebra::NSStringToString(fileName)));
    return [[ImebraDataSet alloc] initWithImebraDataSet:pDataSet.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

+(ImebraDataSet*)loadFromFileMaxSize:(NSString*) fileName maxBufferSize:(unsigned int)maxBufferSize error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::DataSet> pDataSet(imebra::CodecFactory::load(imebra::NSStringToString(fileName), maxBufferSize));
    return [[ImebraDataSet alloc] initWithImebraDataSet:pDataSet.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

+(ImebraDataSet*)loadFromStream:(ImebraStreamReader*)pReader error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::DataSet> pDataSet(imebra::CodecFactory::load(*(pReader->m_pReader)));
    return [[ImebraDataSet alloc] initWithImebraDataSet:pDataSet.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

+(ImebraDataSet*)loadFromStreamMaxSize:(ImebraStreamReader*)pReader maxBufferSize:(unsigned int)maxBufferSize error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    std::unique_ptr<imebra::DataSet> pDataSet(imebra::CodecFactory::load(*(pReader->m_pReader), maxBufferSize));
    return [[ImebraDataSet alloc] initWithImebraDataSet:pDataSet.release()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

+(void)saveToFile:(NSString*)fileName dataSet:(ImebraDataSet*)pDataSet codecType:(ImebraCodecType_t)codecType error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    imebra::CodecFactory::save(*(pDataSet->m_pDataSet), imebra::NSStringToString(fileName), (imebra::codecType_t)codecType);

    OBJC_IMEBRA_FUNCTION_END();
}

+(void)saveToStream:(ImebraStreamWriter*)pWriter dataSet:(ImebraDataSet*)pDataSet codecType:(ImebraCodecType_t) codecType error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    imebra::CodecFactory::save(*(pDataSet->m_pDataSet), *(pWriter->m_pWriter), (imebra::codecType_t)codecType);

    OBJC_IMEBRA_FUNCTION_END();

}

+(void)setMaximumImageSize:(unsigned int)maximumWidth maxHeight:(unsigned int)maximumHeight
{
    imebra::CodecFactory::setMaximumImageSize((const::uint32_t)maximumWidth, (const::uint32_t)maximumHeight);
}


@end




