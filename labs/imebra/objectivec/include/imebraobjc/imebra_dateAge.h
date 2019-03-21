/*
Copyright 2005 - 2017 by Paolo Brandoli/Binarno s.p.

Imebra is available for free under the GNU General Public License.

The full text of the license is available in the file license.rst
 in the project root folder.

If you do not want to be bound by the GPL terms (such as the requirement
 that your application must also be GPL), you may purchase a commercial
 license for Imebra from the Imebra’s website (http://imebra.com).
*/

#if !defined(imebraObjcDateAge__INCLUDED_)
#define imebraObjcDateAge__INCLUDED_

#import <Foundation/Foundation.h>

#ifndef __IMEBRA_OBJECTIVEC_BRIDGING__
namespace imebra
{
struct Age;
struct Date;
}
#endif

/// \enum ImebraAgeUnit_t
/// \brief Used by ImebraAge::setAge() and ImebraAge::getAge() to specify the
///        unit of the age value.
///
///////////////////////////////////////////////////////////////////////////////
typedef NS_ENUM(char, ImebraAgeUnit_t)
{
    ImebraDays = (char)'D',   ///< Days
    ImebraWeeks = (char)'W',  ///< Weeks
    ImebraMonths = (char)'M', ///< Months
    ImebraYears = (char)'Y'   ///< Years
};

///
/// \brief Specifies an age, in days, weeks, months or years.
///
///////////////////////////////////////////////////////////////////////////////
@interface ImebraAge: NSObject

#ifndef __IMEBRA_OBJECTIVEC_BRIDGING__
{
    @public
    imebra::Age* m_pAge;

}
#endif

    -(void)dealloc;

    /// \brief Constructor.
    ///
    /// \param initialAge the initial age to assign to the object, in days, weeks,
    ///                   months or years, depending on the parameter initialUnits
    /// \param initialUnits the units of the value in initialAge
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(id)initWithAge:(unsigned int)initialAge units:(ImebraAgeUnit_t)initialUnits;

    /// \brief Return the age in years.
    ///
    /// \return the stored age converted to years.
    ///
    ///////////////////////////////////////////////////////////////////////////////
    @property (readonly) double years;

    /// \brief Return the age in the units returned by the property units.
    ///
    /// \return the stored age, speficied using the stored units.
    ///
    ///////////////////////////////////////////////////////////////////////////////
    @property (readonly) unsigned int age;

    /// \brief Return the age's units.
    ///
    /// \return the age's units
    ///
    ///////////////////////////////////////////////////////////////////////////////
    @property (readonly) ImebraAgeUnit_t units;

@end


@interface ImebraDate: NSObject

#ifndef __IMEBRA_OBJECTIVEC_BRIDGING__
{
    @public
    imebra::Date* m_pDate;
}
#endif

    -(void)dealloc;

    /// \brief Constructor.
    ///
    /// Initialize the Date structure with the specified values.
    ///
    /// \param initialYear    year (0 = unused)
    /// \param initialMonth   month (1...12, 0 = unused)
    /// \param initialDay     day of the month (1...31, 0 = unused)
    /// \param initialHour    hour (0...23)
    /// \param initialMinutes minutes (0...59)
    /// \param initialSeconds seconds (0...59)
    /// \param initialNanoseconds nanoseconds
    /// \param initialOffsetHours   hours offset from UTC
    /// \param initialOffsetMinutes minutes offset from UTC
    ///////////////////////////////////////////////////////////////////////////////
    -(id)initWithYear:(unsigned int)initialYear
                                    month:(unsigned int)initialMonth
                                    day:(unsigned int)initialDay
                                    hour:(unsigned int)initialHour
                                    minutes:(unsigned int)initialMinutes
                                    seconds:(unsigned int)initialSeconds
                                    nanoseconds:(unsigned int)initialNanoseconds
                                    offsetHours:(int)initialOffsetHours
                                    offsetMinutes:(int)initialOffsetMinutes;

    @property (readonly) unsigned int year;         ///< Year (0 = unused)
    @property (readonly) unsigned int month;        ///< Month (1...12, 0 = unused)
    @property (readonly) unsigned int day;          ///< Day (1...12, 0 = unused)
    @property (readonly) unsigned int hour;         ///< Hours
    @property (readonly) unsigned int minutes;      ///< Minutes
    @property (readonly) unsigned int seconds;      ///< Seconds
    @property (readonly) unsigned int nanoseconds;  ///< Nanoseconds
    @property (readonly) int offsetHours;           ///< Offset hours from UTC
    @property (readonly) int offsetMinutes;         ///< Offset minutes from UTC

@end

#endif // imebraObjcDateAge__INCLUDED_
