#include <imebra/imebra.h>
#include <gtest/gtest.h>

namespace imebra
{

namespace tests
{

TEST(dateTimeHandlerTest, dateTest)
{
    DataSet testDataSet;

    testDataSet.setDate(TagId(0x0008, 0x0012), Date(2004, 11, 5, 9, 20, 30, 5000, 1, 2));
    std::unique_ptr<Date> checkDate(testDataSet.getDate(TagId(0x0008, 0x0012), 0));
    std::string checkString = testDataSet.getString(TagId(0x0008, 0x0012), 0);
    EXPECT_EQ("20041105", checkString);
    EXPECT_EQ(2004u, checkDate->year);
    EXPECT_EQ(11u, checkDate->month);
    EXPECT_EQ(5u, checkDate->day);
    EXPECT_EQ(0u, checkDate->hour);
    EXPECT_EQ(0u, checkDate->minutes);
    EXPECT_EQ(0u, checkDate->seconds);
    EXPECT_EQ(0u, checkDate->nanoseconds);
    EXPECT_EQ(0, checkDate->offsetHours);
    EXPECT_EQ(0, checkDate->offsetMinutes);
    EXPECT_EQ(tagVR_t::DA, testDataSet.getDataType(TagId(0x0008, 0x0012)));


    testDataSet.setString(TagId(0x0008, 0x0012), "20120910");
    std::unique_ptr<Date> checkDate1(testDataSet.getDate(TagId(0x0008, 0x0012), 0));
    EXPECT_EQ(2012u, checkDate1->year);
    EXPECT_EQ(9u, checkDate1->month);
    EXPECT_EQ(10u, checkDate1->day);
    EXPECT_EQ(0u, checkDate1->hour);
    EXPECT_EQ(0u, checkDate1->minutes);
    EXPECT_EQ(0u, checkDate1->seconds);
    EXPECT_EQ(0u, checkDate1->nanoseconds);
    EXPECT_EQ(0, checkDate1->offsetHours);
    EXPECT_EQ(0, checkDate1->offsetMinutes);
}

TEST(dateTimeHandlerTest, timeTest)
{
    DataSet testDataSet;

    {
        testDataSet.setDate(TagId(0x0008, 0x0013), Date(2004, 11, 5, 9, 20, 30, 5000, 1, 2));
        std::unique_ptr<Date> checkDate(testDataSet.getDate(TagId(0x0008, 0x0013), 0));
        std::string checkString = testDataSet.getString(TagId(0x0008, 0x0013), 0);
        EXPECT_EQ("092030.005000", checkString);
        EXPECT_EQ(0u, checkDate->year);
        EXPECT_EQ(0u, checkDate->month);
        EXPECT_EQ(0u, checkDate->day);
        EXPECT_EQ(9u, checkDate->hour);
        EXPECT_EQ(20u, checkDate->minutes);
        EXPECT_EQ(30u, checkDate->seconds);
        EXPECT_EQ(5000u, checkDate->nanoseconds);
        EXPECT_EQ(0, checkDate->offsetHours);
        EXPECT_EQ(0, checkDate->offsetMinutes);
        EXPECT_EQ(tagVR_t::TM, testDataSet.getDataType(TagId(0x0008, 0x0013)));
    }

    {
        testDataSet.setString(TagId(0x0008, 0x0013), "101502");
        std::unique_ptr<Date> checkDate(testDataSet.getDate(TagId(0x0008, 0x0013), 0));
        EXPECT_EQ(0u, checkDate->year);
        EXPECT_EQ(0u, checkDate->month);
        EXPECT_EQ(0u, checkDate->day);
        EXPECT_EQ(10u, checkDate->hour);
        EXPECT_EQ(15u, checkDate->minutes);
        EXPECT_EQ(2u, checkDate->seconds);
        EXPECT_EQ(0u, checkDate->nanoseconds);
        EXPECT_EQ(0, checkDate->offsetHours);
        EXPECT_EQ(0, checkDate->offsetMinutes);
    }

    {
        testDataSet.setString(TagId(0x0008, 0x0013), "1015");
        std::unique_ptr<Date> checkDate(testDataSet.getDate(TagId(0x0008, 0x0013), 0));
        EXPECT_EQ(0u, checkDate->year);
        EXPECT_EQ(0u, checkDate->month);
        EXPECT_EQ(0u, checkDate->day);
        EXPECT_EQ(10u, checkDate->hour);
        EXPECT_EQ(15u, checkDate->minutes);
        EXPECT_EQ(0u, checkDate->seconds);
        EXPECT_EQ(0u, checkDate->nanoseconds);
        EXPECT_EQ(0, checkDate->offsetHours);
        EXPECT_EQ(0, checkDate->offsetMinutes);
    }
}

TEST(dateTimeHandlerTest, dateTimeTest)
{
    DataSet testDataSet;

    Date testDate(2004, 11, 5, 9, 20, 40, 5000, 1, 2);
    testDataSet.setDate(TagId(0x0008, 0x002A), testDate);

    std::unique_ptr<Date> checkDate(testDataSet.getDate(TagId(0x0008, 0x002A), 0));

    EXPECT_EQ(2004u, checkDate->year);
    EXPECT_EQ(11u, checkDate->month);
    EXPECT_EQ(5u, checkDate->day);
    EXPECT_EQ(9u, checkDate->hour);
    EXPECT_EQ(20u, checkDate->minutes);
    EXPECT_EQ(40u, checkDate->seconds);
    EXPECT_EQ(5000u, checkDate->nanoseconds);
    EXPECT_EQ(1, checkDate->offsetHours);
    EXPECT_EQ(2, checkDate->offsetMinutes);

    EXPECT_EQ("20041105092040.005000+0102", testDataSet.getString(TagId(0x0008, 0x002A), 0));
}


TEST(dateTimeHandlerTest, incompleteDateTimeTest)
{
    DataSet testDataSet;

    testDataSet.setString(TagId(0x0008, 0x002A), "19990120");
    std::unique_ptr<Date> checkDate(testDataSet.getDate(TagId(0x0008, 0x002A), 0));

    EXPECT_EQ(1999u, checkDate->year);
    EXPECT_EQ(1u, checkDate->month);
    EXPECT_EQ(20u, checkDate->day);
    EXPECT_EQ(0u, checkDate->hour);
    EXPECT_EQ(0u, checkDate->minutes);
    EXPECT_EQ(0u, checkDate->seconds);
    EXPECT_EQ(0u, checkDate->nanoseconds);
    EXPECT_EQ(0, checkDate->offsetHours);
    EXPECT_EQ(0, checkDate->offsetMinutes);

    testDataSet.setString(TagId(0x0008, 0x002A), "1999012012");
    checkDate.reset(testDataSet.getDate(TagId(0x0008, 0x002A), 0));

    EXPECT_EQ(1999u, checkDate->year);
    EXPECT_EQ(1u, checkDate->month);
    EXPECT_EQ(20u, checkDate->day);
    EXPECT_EQ(12u, checkDate->hour);
    EXPECT_EQ(0u, checkDate->minutes);
    EXPECT_EQ(0u, checkDate->seconds);
    EXPECT_EQ(0u, checkDate->nanoseconds);
    EXPECT_EQ(0, checkDate->offsetHours);
    EXPECT_EQ(0, checkDate->offsetMinutes);
}

} // namespace tests

} // namespace imebra

