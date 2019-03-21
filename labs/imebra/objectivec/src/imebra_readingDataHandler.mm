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

@implementation ImebraReadingDataHandler

-(id)initWithImebraReadingDataHandler:(imebra::ReadingDataHandler*)pReadingDataHandler
{
    self = [super init];
    if(self)
    {
        m_pReadingDataHandler = pReadingDataHandler;
    }
    else
    {
        delete pReadingDataHandler;
    }
    return self;

}

-(void)dealloc
{
    delete m_pReadingDataHandler;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(unsigned int) size
{
    return (unsigned int)m_pReadingDataHandler->getSize();
}

-(int) getSignedLong:(unsigned int)index error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return m_pReadingDataHandler->getSignedLong(index);

    OBJC_IMEBRA_FUNCTION_END_RETURN(0);
}

-(unsigned int) getUnsignedLong:(unsigned int)index error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return m_pReadingDataHandler->getUnsignedLong(index);

    OBJC_IMEBRA_FUNCTION_END_RETURN(0);
}

-(double) getDouble:(unsigned int)index error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return m_pReadingDataHandler->getDouble(index);

    OBJC_IMEBRA_FUNCTION_END_RETURN(0.0f);
}

-(NSString*) getString:(unsigned int)index error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return imebra::stringToNSString(m_pReadingDataHandler->getString(index));

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraDate*) getDate:(unsigned int)index error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    imebra::Date date(m_pReadingDataHandler->getDate(index));
    return [[ImebraDate alloc] initWithYear:date.year
            month:date.month
            day:date.day
            hour:date.hour
            minutes:date.minutes
            seconds:date.seconds
            nanoseconds:date.nanoseconds
            offsetHours:date.offsetHours
            offsetMinutes:date.offsetMinutes];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraAge*) getAge:(unsigned int)index error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    imebra::Age age(m_pReadingDataHandler->getAge(index));
    return [[ImebraAge alloc] initWithAge:age.age
            units:(ImebraAgeUnit_t)age.units];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}


@end


