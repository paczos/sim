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

@implementation ImebraWritingDataHandler

-(id)initWithImebraWritingDataHandler:(void*)pWritingDataHandler
{
    self = [super init];
    if(self)
    {
        m_pWritingDataHandlerVoidPointer = pWritingDataHandler;
    }
    else
    {
        delete castWritingDataHandler(pWritingDataHandler);
    }
    return self;
}

-(void)dealloc
{
    delete m_pWritingDataHandler;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(unsigned int)size
{
    if(m_pWritingDataHandler != 0)
    {
        return (unsigned int)m_pWritingDataHandler->getSize();
    }
    else
    {
        return 0;
    }
}

-(void)setSize:(unsigned int)size
{
    if(m_pWritingDataHandler != 0)
    {
        m_pWritingDataHandler->setSize(size);
    }
}

-(void) setSignedLong:(unsigned int)index newValue:(int)value error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    if(m_pWritingDataHandler != 0)
    {
        m_pWritingDataHandler->setSignedLong(index, value);
    }

    OBJC_IMEBRA_FUNCTION_END();
}

-(void) setUnsignedLong:(unsigned int)index newValue:(unsigned int)value error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    if(m_pWritingDataHandler != 0)
    {
        m_pWritingDataHandler->setUnsignedLong(index, value);
    }

    OBJC_IMEBRA_FUNCTION_END();
}

-(void) setDouble:(unsigned int)index newValue:(double)value error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    if(m_pWritingDataHandler != 0)
    {
        m_pWritingDataHandler->setDouble(index, value);
    }

    OBJC_IMEBRA_FUNCTION_END();
}

-(void) setString:(unsigned int)index newValue:(NSString*)value error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    if(m_pWritingDataHandler != 0)
    {
        m_pWritingDataHandler->setString(index, imebra::NSStringToString(value));
    }

    OBJC_IMEBRA_FUNCTION_END();
}

-(void) setDate:(unsigned int)index newValue:(ImebraDate*)value error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    if(m_pWritingDataHandler != 0)
    {
        m_pWritingDataHandler->setDate(index, *(imebra::Date*)(value->m_pDate));
    }

    OBJC_IMEBRA_FUNCTION_END();
}

-(void) setAge:(unsigned int)index newValue:(ImebraAge*)value error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    if(m_pWritingDataHandler != 0)
    {
        m_pWritingDataHandler->setAge(index, *(imebra::Age*)(value->m_pAge));
    }

    OBJC_IMEBRA_FUNCTION_END();
}

-(void) commit
{
    if(m_pWritingDataHandler != 0)
    {
        delete m_pWritingDataHandler;
        m_pWritingDataHandlerVoidPointer = 0;
    }
}

@end

