#include <imebra/imebra.h>
#include <gtest/gtest.h>


namespace imebra
{

namespace tests
{

TEST(lut, simpleLut)
{
    DataSet testDataSet;
    std::unique_ptr<Tag> sequenceTag(testDataSet.getTagCreate(TagId(tagId_t::ModalityLUTSequence_0028_3000)));
    DataSet lutItem;
    {
        std::unique_ptr<WritingDataHandlerNumeric> descriptor(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTDescriptor_0028_3002), 0, tagVR_t::US));
        std::unique_ptr<WritingDataHandlerNumeric> data(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTData_0028_3006), 0, tagVR_t::US));
        lutItem.setString(TagId(tagId_t::LUTExplanation_0028_3003), "Test LUT");

        descriptor->setUnsignedLong(0, 3u);
        descriptor->setUnsignedLong(1, 2u);
        descriptor->setUnsignedLong(2, 16u);

        data->setUnsignedLong(0, 100u);
        data->setUnsignedLong(1, 200u);
        data->setUnsignedLong(2, 300u);
    }
    sequenceTag->setSequenceItem(0, lutItem);

    {
        std::unique_ptr<LUT> lut(testDataSet.getLUT(TagId(tagId_t::ModalityLUTSequence_0028_3000), 0));
        ASSERT_EQ(L"Test LUT", lut->getDescription());
        ASSERT_EQ(3u, lut->getSize());
        ASSERT_EQ(16u, lut->getBits());
        ASSERT_EQ(2, lut->getFirstMapped());
        ASSERT_EQ(100u, lut->getMappedValue(0));
        ASSERT_EQ(100u, lut->getMappedValue(1));
        ASSERT_EQ(100u, lut->getMappedValue(2));
        ASSERT_EQ(200u, lut->getMappedValue(3));
        ASSERT_EQ(300u, lut->getMappedValue(4));
        ASSERT_EQ(300u, lut->getMappedValue(5));
    }
}

TEST(lut, simpleLutNegative)
{
    DataSet testDataSet;
    std::unique_ptr<Tag> sequenceTag(testDataSet.getTagCreate(TagId(tagId_t::ModalityLUTSequence_0028_3000)));
    DataSet lutItem;
    testDataSet.setUnsignedLong(TagId(tagId_t::PixelRepresentation_0028_0103), 1);
    {
        std::unique_ptr<WritingDataHandlerNumeric> descriptor(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTDescriptor_0028_3002), 0, tagVR_t::US));
        std::unique_ptr<WritingDataHandlerNumeric> data(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTData_0028_3006), 0, tagVR_t::US));
        lutItem.setString(TagId(tagId_t::LUTExplanation_0028_3003), "Test LUT");

        descriptor->setUnsignedLong(0, 3);
        descriptor->setSignedLong(1, -2);
        descriptor->setUnsignedLong(2, 16);

        data->setUnsignedLong(0, 100);
        data->setUnsignedLong(1, 200);
        data->setUnsignedLong(2, 300);
    }
    sequenceTag->setSequenceItem(0, lutItem);

    {
        std::unique_ptr<LUT> lut(testDataSet.getLUT(TagId(tagId_t::ModalityLUTSequence_0028_3000), 0));
        ASSERT_EQ(L"Test LUT", lut->getDescription());
        ASSERT_EQ(3u, lut->getSize());
        ASSERT_EQ(16u, lut->getBits());
        ASSERT_EQ(-2, lut->getFirstMapped());
        ASSERT_EQ(100u, lut->getMappedValue(-4));
        ASSERT_EQ(100u, lut->getMappedValue(-3));
        ASSERT_EQ(100u, lut->getMappedValue(-2));
        ASSERT_EQ(200u, lut->getMappedValue(-1));
        ASSERT_EQ(300u, lut->getMappedValue(0));
        ASSERT_EQ(300u, lut->getMappedValue(1));
    }
}

TEST(lut, simpleLutCorruptedDescriptor)
{
    DataSet testDataSet;
    std::unique_ptr<Tag> sequenceTag(testDataSet.getTagCreate(TagId(tagId_t::ModalityLUTSequence_0028_3000)));
    DataSet lutItem;
    testDataSet.setUnsignedLong(TagId(tagId_t::PixelRepresentation_0028_0103), 1);
    {
        std::unique_ptr<WritingDataHandlerNumeric> descriptor(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTDescriptor_0028_3002), 0, tagVR_t::US));
        std::unique_ptr<WritingDataHandlerNumeric> data(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTData_0028_3006), 0, tagVR_t::US));
        lutItem.setString(TagId(tagId_t::LUTExplanation_0028_3003), "Test LUT");

        descriptor->setUnsignedLong(0, 3u);
        descriptor->setSignedLong(1, -2);
        descriptor->setUnsignedLong(2, 16u);
        descriptor->setUnsignedLong(3, 0u);

        data->setUnsignedLong(0, 100u);
        data->setUnsignedLong(1, 200u);
        data->setUnsignedLong(2, 300u);
    }
    sequenceTag->setSequenceItem(0, lutItem);

    ASSERT_THROW(testDataSet.getLUT(TagId(tagId_t::ModalityLUTSequence_0028_3000), 0), LutCorruptedError);
}

TEST(lut, simpleLutCorruptedDescriptor1)
{
    DataSet testDataSet;
    std::unique_ptr<Tag> sequenceTag(testDataSet.getTagCreate(TagId(tagId_t::ModalityLUTSequence_0028_3000)));
    DataSet lutItem;
    testDataSet.setUnsignedLong(TagId(tagId_t::PixelRepresentation_0028_0103), 1);
    {
        std::unique_ptr<WritingDataHandlerNumeric> descriptor(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTDescriptor_0028_3002), 0, tagVR_t::US));
        std::unique_ptr<WritingDataHandlerNumeric> data(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTData_0028_3006), 0, tagVR_t::US));
        lutItem.setString(TagId(tagId_t::LUTExplanation_0028_3003), "Test LUT");

        descriptor->setUnsignedLong(0, 3);
        descriptor->setSignedLong(1, -2);

        data->setUnsignedLong(0, 100u);
        data->setUnsignedLong(1, 200u);
        data->setUnsignedLong(2, 300u);
    }
    sequenceTag->setSequenceItem(0, lutItem);

    ASSERT_THROW(testDataSet.getLUT(TagId(tagId_t::ModalityLUTSequence_0028_3000), 0), LutCorruptedError);
}

TEST(lut, simpleLutCorruptedDescriptor2)
{
    DataSet testDataSet;
    std::unique_ptr<Tag> sequenceTag(testDataSet.getTagCreate(TagId(tagId_t::ModalityLUTSequence_0028_3000)));
    DataSet lutItem;
    testDataSet.setUnsignedLong(TagId(tagId_t::PixelRepresentation_0028_0103), 1);
    {
        std::unique_ptr<WritingDataHandlerNumeric> descriptor(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTDescriptor_0028_3002), 0, tagVR_t::US));
        std::unique_ptr<WritingDataHandlerNumeric> data(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTData_0028_3006), 0, tagVR_t::US));
        lutItem.setString(TagId(tagId_t::LUTExplanation_0028_3003), "Test LUT");

        descriptor->setUnsignedLong(0, 3u);
        descriptor->setSignedLong(1, -2);
        descriptor->setUnsignedLong(2, 17u);

        data->setUnsignedLong(0, 100u);
        data->setUnsignedLong(1, 200u);
        data->setUnsignedLong(2, 300u);
    }
    sequenceTag->setSequenceItem(0, lutItem);

    ASSERT_THROW(testDataSet.getLUT(TagId(tagId_t::ModalityLUTSequence_0028_3000), 0), LutCorruptedError);
}

TEST(lut, simpleLutCorruptedDescriptor3)
{
    DataSet testDataSet;
    std::unique_ptr<Tag> sequenceTag(testDataSet.getTagCreate(TagId(tagId_t::ModalityLUTSequence_0028_3000)));
    DataSet lutItem;
    testDataSet.setUnsignedLong(TagId(tagId_t::PixelRepresentation_0028_0103), 1);
    {
        std::unique_ptr<WritingDataHandlerNumeric> descriptor(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTDescriptor_0028_3002), 0, tagVR_t::US));
        std::unique_ptr<WritingDataHandlerNumeric> data(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTData_0028_3006), 0, tagVR_t::US));
        lutItem.setString(TagId(tagId_t::LUTExplanation_0028_3003), "Test LUT");

        descriptor->setUnsignedLong(0, 4u);
        descriptor->setSignedLong(1, -2);
        descriptor->setUnsignedLong(2, 16u);

        data->setUnsignedLong(0, 100u);
        data->setUnsignedLong(1, 200u);
        data->setUnsignedLong(2, 300u);
    }
    sequenceTag->setSequenceItem(0, lutItem);

    ASSERT_THROW(testDataSet.getLUT(TagId(tagId_t::ModalityLUTSequence_0028_3000), 0), LutCorruptedError);
}

TEST(lut, simpleLut16bitFull)
{
    DataSet testDataSet;
    std::unique_ptr<Tag> sequenceTag(testDataSet.getTagCreate(TagId(tagId_t::ModalityLUTSequence_0028_3000)));
    DataSet lutItem;
    {
        std::unique_ptr<WritingDataHandlerNumeric> descriptor(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTDescriptor_0028_3002), 0, tagVR_t::US));
        std::unique_ptr<WritingDataHandlerNumeric> data(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTData_0028_3006), 0, tagVR_t::US));
        lutItem.setString(TagId(tagId_t::LUTExplanation_0028_3003), "Test LUT");

        descriptor->setUnsignedLong(0, 0u);
        descriptor->setUnsignedLong(1, 0u);
        descriptor->setUnsignedLong(2, 16u);

        for(std::uint32_t fillLut(0); fillLut != 65536u; ++fillLut)
        {
            data->setUnsignedLong(fillLut, fillLut);
        }
    }
    sequenceTag->setSequenceItem(0, lutItem);

    {
        std::unique_ptr<LUT> lut(testDataSet.getLUT(TagId(tagId_t::ModalityLUTSequence_0028_3000), 0));
        ASSERT_EQ(L"Test LUT", lut->getDescription());
        ASSERT_EQ(65536u, lut->getSize());
        ASSERT_EQ(16u, lut->getBits());
        ASSERT_EQ(0, lut->getFirstMapped());
        for(std::uint32_t checkLut(0); checkLut != 65536; ++checkLut)
        {
            ASSERT_EQ(checkLut, lut->getMappedValue((std::int32_t)checkLut));
        }
    }
}

}

}

