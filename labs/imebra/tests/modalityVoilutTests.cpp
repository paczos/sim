#include <imebra/imebra.h>
#include "buildImageForTest.h"
#include <gtest/gtest.h>


namespace imebra
{

namespace tests
{

TEST(modalityVoilut, voilutUnsigned8)
{
    Image unsigned8(6, 1, bitDepth_t::depthU8, "MONOCHROME2", 7);
    {
        std::unique_ptr<WritingDataHandler> unsigned8Handler(unsigned8.getWritingDataHandler());
        unsigned8Handler->setUnsignedLong(0, 0);
        unsigned8Handler->setUnsignedLong(1, 10);
        unsigned8Handler->setUnsignedLong(2, 20);
        unsigned8Handler->setUnsignedLong(3, 30);
        unsigned8Handler->setUnsignedLong(4, 40);
        unsigned8Handler->setUnsignedLong(5, 50);
    }

    DataSet testDataSet("1.2.840.10008.1.2.1");
    testDataSet.setDouble(TagId(tagId_t::RescaleSlope_0028_1053), 2);
    testDataSet.setDouble(TagId(tagId_t::RescaleIntercept_0028_1052), -1);
    testDataSet.setImage(0, unsigned8, imageQuality_t::veryHigh);

    {
        ModalityVOILUT voilut(testDataSet);

        std::unique_ptr<Image> signed8Out(voilut.allocateOutputImage(unsigned8, 6, 1));
        voilut.runTransform(unsigned8, 0, 0, 6, 1, *signed8Out, 0, 0);
        ASSERT_EQ(bitDepth_t::depthS16, signed8Out->getDepth());

        std::unique_ptr<ReadingDataHandler> signed8Handler(signed8Out->getReadingDataHandler());

        ASSERT_EQ(-1, signed8Handler->getSignedLong(0));
        ASSERT_EQ(19, signed8Handler->getSignedLong(1));
        ASSERT_EQ(39, signed8Handler->getSignedLong(2));
        ASSERT_EQ(59, signed8Handler->getSignedLong(3));
        ASSERT_EQ(79, signed8Handler->getSignedLong(4));
        ASSERT_EQ(99, signed8Handler->getSignedLong(5));
    }

    {
        std::unique_ptr<Image> signed8Out(testDataSet.getImageApplyModalityTransform(0));
        ASSERT_EQ(bitDepth_t::depthS16, signed8Out->getDepth());

        std::unique_ptr<ReadingDataHandler> signed8Handler(signed8Out->getReadingDataHandler());

        ASSERT_EQ(-1, signed8Handler->getSignedLong(0));
        ASSERT_EQ(19, signed8Handler->getSignedLong(1));
        ASSERT_EQ(39, signed8Handler->getSignedLong(2));
        ASSERT_EQ(59, signed8Handler->getSignedLong(3));
        ASSERT_EQ(79, signed8Handler->getSignedLong(4));
        ASSERT_EQ(99, signed8Handler->getSignedLong(5));
    }
}


TEST(modalityVoilut, voilutSigned8)
{
    Image unsigned8(6, 1, bitDepth_t::depthS8, "MONOCHROME2", 7);
    {
        std::unique_ptr<WritingDataHandler> unsigned8Handler(unsigned8.getWritingDataHandler());
        unsigned8Handler->setUnsignedLong(0, -30);
        unsigned8Handler->setUnsignedLong(1, -20);
        unsigned8Handler->setUnsignedLong(2, -10);
        unsigned8Handler->setUnsignedLong(3, 0);
        unsigned8Handler->setUnsignedLong(4, 10);
        unsigned8Handler->setUnsignedLong(5, 20);
    }

    DataSet testDataSet("1.2.840.10008.1.2.1");
    testDataSet.setDouble(TagId(tagId_t::RescaleSlope_0028_1053), 2);
    testDataSet.setDouble(TagId(tagId_t::RescaleIntercept_0028_1052), 40);
    testDataSet.setImage(0, unsigned8, imageQuality_t::veryHigh);

    {
        ModalityVOILUT voilut(testDataSet);

        std::unique_ptr<Image> signed8Out(voilut.allocateOutputImage(unsigned8, 6, 1));
        voilut.runTransform(unsigned8, 0, 0, 6, 1, *signed8Out, 0, 0);
        ASSERT_EQ(bitDepth_t::depthS16, signed8Out->getDepth());

        std::unique_ptr<ReadingDataHandler> signed8Handler(signed8Out->getReadingDataHandler());

        ASSERT_EQ(-20, signed8Handler->getSignedLong(0));
        ASSERT_EQ(0, signed8Handler->getSignedLong(1));
        ASSERT_EQ(20, signed8Handler->getSignedLong(2));
        ASSERT_EQ(40, signed8Handler->getSignedLong(3));
        ASSERT_EQ(60, signed8Handler->getSignedLong(4));
        ASSERT_EQ(80, signed8Handler->getSignedLong(5));
    }

    {
        std::unique_ptr<Image> signed8Out(testDataSet.getImageApplyModalityTransform(0));
        ASSERT_EQ(bitDepth_t::depthS16, signed8Out->getDepth());

        std::unique_ptr<ReadingDataHandler> signed8Handler(signed8Out->getReadingDataHandler());

        ASSERT_EQ(-20, signed8Handler->getSignedLong(0));
        ASSERT_EQ(0, signed8Handler->getSignedLong(1));
        ASSERT_EQ(20, signed8Handler->getSignedLong(2));
        ASSERT_EQ(40, signed8Handler->getSignedLong(3));
        ASSERT_EQ(60, signed8Handler->getSignedLong(4));
        ASSERT_EQ(80, signed8Handler->getSignedLong(5));
    }
}


TEST(modalityVoilut, voilutUnsigned8LUT)
{
    Image unsigned8(6, 1, bitDepth_t::depthU8, "MONOCHROME2", 7);
    {
        std::unique_ptr<WritingDataHandler> unsigned8Handler(unsigned8.getWritingDataHandler());
        unsigned8Handler->setUnsignedLong(0, 0u);
        unsigned8Handler->setUnsignedLong(1, 1u);
        unsigned8Handler->setUnsignedLong(2, 2u);
        unsigned8Handler->setUnsignedLong(3, 3u);
        unsigned8Handler->setUnsignedLong(4, 4u);
        unsigned8Handler->setUnsignedLong(5, 5u);
    }

    DataSet testDataSet("1.2.840.10008.1.2.1");
    testDataSet.setImage(0, unsigned8, imageQuality_t::veryHigh);
    std::unique_ptr<Tag> sequenceTag(testDataSet.getTagCreate(TagId(tagId_t::ModalityLUTSequence_0028_3000)));
    DataSet lutItem;
    {
        std::unique_ptr<WritingDataHandlerNumeric> descriptor(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTDescriptor_0028_3002), 0, tagVR_t::US));
        std::unique_ptr<WritingDataHandlerNumeric> data(lutItem.getWritingDataHandlerNumeric(TagId(tagId_t::LUTData_0028_3006), 0, tagVR_t::US));
        descriptor->setUnsignedLong(0, 3u);
        descriptor->setUnsignedLong(1, 2u);
        descriptor->setUnsignedLong(2, 16u);

        data->setUnsignedLong(0, 100u);
        data->setUnsignedLong(1, 200u);
        data->setUnsignedLong(2, 300u);
    }
    sequenceTag->setSequenceItem(0, lutItem);

    {
        ModalityVOILUT voilut(testDataSet);

        std::unique_ptr<Image> unsigned8Out(voilut.allocateOutputImage(unsigned8, 6, 1));
        voilut.runTransform(unsigned8, 0, 0, 6, 1, *unsigned8Out, 0, 0);

        std::unique_ptr<ReadingDataHandler> unsignedHandler(unsigned8Out->getReadingDataHandler());

        ASSERT_EQ(100u, unsignedHandler->getUnsignedLong(0));
        ASSERT_EQ(100u, unsignedHandler->getUnsignedLong(1));
        ASSERT_EQ(100u, unsignedHandler->getUnsignedLong(2));
        ASSERT_EQ(200u, unsignedHandler->getUnsignedLong(3));
        ASSERT_EQ(300u, unsignedHandler->getUnsignedLong(4));
        ASSERT_EQ(300u, unsignedHandler->getUnsignedLong(5));
    }

    {
        std::unique_ptr<Image> unsigned8Out(testDataSet.getImageApplyModalityTransform(0));

        std::unique_ptr<ReadingDataHandler> unsignedHandler(unsigned8Out->getReadingDataHandler());

        ASSERT_EQ(100u, unsignedHandler->getUnsignedLong(0));
        ASSERT_EQ(100u, unsignedHandler->getUnsignedLong(1));
        ASSERT_EQ(100u, unsignedHandler->getUnsignedLong(2));
        ASSERT_EQ(200u, unsignedHandler->getUnsignedLong(3));
        ASSERT_EQ(300u, unsignedHandler->getUnsignedLong(4));
        ASSERT_EQ(300u, unsignedHandler->getUnsignedLong(5));
    }
}

}

}

