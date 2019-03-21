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

@implementation ImebraTag

-(id)initWithImebraTag:(imebra::Tag*)pTag
{
    self = [super init];
    if(self)
    {
        m_pTag = pTag;
    }
    else
    {
        delete pTag;
    }
    return self;
}

-(void)dealloc
{
    delete m_pTag;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(unsigned int) getBuffersCount
{
    return (unsigned int)m_pTag->getBuffersCount();
}


-(BOOL) bufferExists:(unsigned int) bufferId
{
    return (BOOL)m_pTag->bufferExists((size_t)bufferId);
}


-(unsigned int) getBufferSize:(unsigned int) bufferId error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return (unsigned int)m_pTag->getBufferSize((size_t)bufferId);

    OBJC_IMEBRA_FUNCTION_END_RETURN(0);
}


-(ImebraReadingDataHandler*) getReadingDataHandler:(unsigned int) bufferId error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraReadingDataHandler alloc] initWithImebraReadingDataHandler:m_pTag->getReadingDataHandler((size_t)bufferId)];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


-(ImebraWritingDataHandler*) getWritingDataHandler:(unsigned int) bufferId error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraWritingDataHandler alloc] initWithImebraWritingDataHandler:m_pTag->getWritingDataHandler((size_t)bufferId)];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


-(ImebraReadingDataHandlerNumeric*) getReadingDataHandlerNumeric:(unsigned int) bufferId error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraReadingDataHandlerNumeric alloc] initWithImebraReadingDataHandler:m_pTag->getReadingDataHandlerNumeric((size_t)bufferId)];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


-(ImebraReadingDataHandlerNumeric*) getReadingDataHandlerRaw:(unsigned int) bufferId error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraReadingDataHandlerNumeric alloc] initWithImebraReadingDataHandler:m_pTag->getReadingDataHandlerRaw((size_t)bufferId)];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


-(ImebraWritingDataHandlerNumeric*) getWritingDataHandlerNumeric:(unsigned int) bufferId error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraWritingDataHandlerNumeric alloc] initWithImebraWritingDataHandler:m_pTag->getWritingDataHandlerNumeric((size_t)bufferId)];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


-(ImebraWritingDataHandlerNumeric*) getWritingDataHandlerRaw:(unsigned int) bufferId error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraWritingDataHandlerNumeric alloc] initWithImebraWritingDataHandler:m_pTag->getWritingDataHandlerRaw((size_t)bufferId)];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


-(ImebraStreamReader*) getStreamReader:(unsigned int) bufferId error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraStreamReader alloc] initWithImebraStreamReader:m_pTag->getStreamReader((size_t)bufferId)];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


-(ImebraStreamWriter*) getStreamWriter:(unsigned int) bufferId error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraStreamWriter alloc] initWithImebraStreamWriter:m_pTag->getStreamWriter((size_t)bufferId)];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


-(ImebraDataSet*) getSequenceItem:(unsigned int) dataSetId error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraDataSet alloc] initWithImebraDataSet:m_pTag->getSequenceItem((size_t)dataSetId)];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


-(BOOL)sequenceItemExists:(unsigned int) dataSetId
{
    return (BOOL)(m_pTag->sequenceItemExists((size_t)dataSetId));
}


-(void) setSequenceItem:(unsigned int) dataSetId dataSet:(ImebraDataSet*)pDataSet error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return m_pTag->setSequenceItem((size_t)dataSetId, *(pDataSet->m_pDataSet));

    OBJC_IMEBRA_FUNCTION_END();
}


-(void) appendSequenceItem:(ImebraDataSet*)pDataSet error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return m_pTag->appendSequenceItem(*(pDataSet->m_pDataSet));

    OBJC_IMEBRA_FUNCTION_END();
}


-(ImebraTagVR_t) dataType
{
    return (ImebraTagVR_t)m_pTag->getDataType();
}

@end

