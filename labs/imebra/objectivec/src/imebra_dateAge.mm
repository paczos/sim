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

#import <Foundation/NSString.h>

@implementation ImebraAge

-(void)dealloc
{
    delete m_pAge;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(id)initWithAge:(unsigned int)initialAge units:(ImebraAgeUnit_t)initialUnits
{
    m_pAge = 0;
    self = [super init];
    if(self)
    {
        m_pAge = new imebra::Age(initialAge, (imebra::ageUnit_t)initialUnits);
    }
    return self;
}

-(double)years
{
    return m_pAge->years();
}

-(unsigned int)age
{
    return m_pAge->age;
}

-(ImebraAgeUnit_t)units
{
    return (ImebraAgeUnit_t)m_pAge->units;
}

@end


@implementation ImebraDate

-(void)dealloc
{
    delete m_pDate;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(id)initWithYear:(unsigned int)initialYear
                                month:(unsigned int)initialMonth
                                day:(unsigned int)initialDay
                                hour:(unsigned int)initialHour
                                minutes:(unsigned int)initialMinutes
                                seconds:(unsigned int)initialSeconds
                                nanoseconds:(unsigned int)initialNanoseconds
                                offsetHours:(int)initialOffsetHours
                                offsetMinutes:(int)initialOffsetMinutes
{
    self = [super init];
    if(self)
    {
        self->m_pDate =
                    new imebra::Date(
                        initialYear,
                        initialMonth,
                        initialDay,
                        initialHour,
                        initialMinutes,
                        initialSeconds,
                        initialNanoseconds,
                        initialOffsetHours,
                        initialOffsetMinutes);
    }
    return self;
}

-(unsigned int)year
{
    return m_pDate->year;
}

-(unsigned int)month
{
    return m_pDate->month;
}

-(unsigned int)day
{
    return m_pDate->day;
}

-(unsigned int)hour
{
    return m_pDate->hour;
}

-(unsigned int)minutes
{
    return m_pDate->minutes;
}

-(unsigned int)seconds
{
    return m_pDate->seconds;
}

-(unsigned int)nanoseconds
{
    return m_pDate->nanoseconds;
}

-(int)offsetHours
{
    return m_pDate->offsetHours;
}

-(int)offsetMinutes
{
    return m_pDate->offsetMinutes;
}

@end
