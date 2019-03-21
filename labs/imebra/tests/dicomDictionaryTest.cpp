#include <imebra/imebra.h>
#include <gtest/gtest.h>

namespace imebra
{

namespace tests
{

TEST(dicomDictionaryTest, getTagInfo)
{
    ASSERT_TRUE(DicomDictionary::getTagName(TagId(tagId_t::PatientName_0010_0010)).find("Patient") != std::string::npos);
    ASSERT_TRUE(DicomDictionary::getUnicodeTagName(TagId(tagId_t::PatientName_0010_0010)).find(L"Patient") != std::string::npos);
    ASSERT_EQ(tagVR_t::PN, DicomDictionary::getTagType(TagId(tagId_t::PatientName_0010_0010)));
    ASSERT_EQ(64u, DicomDictionary::getMaxSize(tagVR_t::PN));
    ASSERT_EQ(4u, DicomDictionary::getWordSize(tagVR_t::UL));
}


TEST(dicomDictionaryTest, testMask)
{
    for(std::uint16_t overlayRow(0); overlayRow != 0x0100; ++overlayRow)
    {
        ASSERT_TRUE(DicomDictionary::getTagName(TagId(0x6000 | overlayRow, 0x0010)).find("Overlay Row") != std::string::npos);
    }

    ASSERT_THROW(DicomDictionary::getTagName(TagId(0x6100, 0x0010)), DictionaryUnknownTagError);
}

} // namespace tests

} // namespace imebra
