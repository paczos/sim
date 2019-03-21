#include <gtest/gtest.h>
#include <imebra/imebra.h>

namespace imebra
{

namespace tests
{


// Test implementation of streamReader::readSome
TEST(streamTest, testReadSome)
{
    ReadWriteMemory memory;
    MemoryStreamOutput memoryOutput(memory);

    {
        StreamWriter memoryWriter(memoryOutput);

        DataSet testDataSet("1.2.840.10008.1.2.1");
        testDataSet.setString(TagId(tagId_t::PatientName_0010_0010), "Test Patient");

        CodecFactory::save(testDataSet, memoryWriter, codecType_t::dicom);
    }

    MemoryStreamInput memoryInput(memory);
    StreamReader memoryReader(memoryInput);
    std::unique_ptr<DataSet> pDataSet(CodecFactory::load(memoryReader));
    ASSERT_EQ("Test Patient", pDataSet->getString(TagId(tagId_t::PatientName_0010_0010), 0));

    ASSERT_THROW(CodecFactory::load(memoryReader), StreamEOFError);
}


// Test implementation of streamReader::readSome
TEST(streamTest, testVirtualStream)
{
    ReadWriteMemory memory;

    size_t size0, size1, size2;

    {
        MemoryStreamOutput memoryOutput(memory);
        StreamWriter memoryWriter(memoryOutput);
        {

            DataSet testDataSet("1.2.840.10008.1.2.1");
            testDataSet.setString(TagId(tagId_t::PatientName_0010_0010), "Test Patient0");

            CodecFactory::save(testDataSet, memoryWriter, codecType_t::dicom);

            size0 = memory.size();
        }

        {
            DataSet testDataSet("1.2.840.10008.1.2.1");
            testDataSet.setString(TagId(tagId_t::PatientName_0010_0010), "Test Patient1");

            CodecFactory::save(testDataSet, memoryWriter, codecType_t::dicom);

            size1 = memory.size() - size0;
        }

        {
            DataSet testDataSet("1.2.840.10008.1.2.1");
            testDataSet.setString(TagId(tagId_t::PatientName_0010_0010), "Test Patient2");

            CodecFactory::save(testDataSet, memoryWriter, codecType_t::dicom);

            size2 = memory.size() - size1 - size0;
        }
    }

    MemoryStreamInput memoryInput(memory);
    StreamReader memoryReader(memoryInput);

    {
        std::unique_ptr<StreamReader> virtualReader(memoryReader.getVirtualStream(size0));
        std::unique_ptr<DataSet> pDataSet(CodecFactory::load(*virtualReader));
        ASSERT_EQ("Test Patient0", pDataSet->getString(TagId(tagId_t::PatientName_0010_0010), 0));
    }

    {
        std::unique_ptr<StreamReader> virtualReader(memoryReader.getVirtualStream(size1));
        std::unique_ptr<DataSet> pDataSet(CodecFactory::load(*virtualReader));
        ASSERT_EQ("Test Patient1", pDataSet->getString(TagId(tagId_t::PatientName_0010_0010), 0));
    }

    {
        std::unique_ptr<StreamReader> virtualReader(memoryReader.getVirtualStream(size2));
        std::unique_ptr<DataSet> pDataSet(CodecFactory::load(*virtualReader));
        ASSERT_EQ("Test Patient2", pDataSet->getString(TagId(tagId_t::PatientName_0010_0010), 0));
    }
}


// Test the StreamTimeout class
TEST(streamTest, testTimeout)
{
    std::string string;
    try
    {
        Pipe pipe(1024);

        {
            StreamTimeout timeout(pipe, 2);

            ReadMemory input1("ABCD", 4);
            pipe.feed(input1);

            ReadWriteMemory readData(4);
            pipe.sink(readData);
            size_t dataSize;
            char* data(readData.data(&dataSize));
            string += std::string(data, dataSize);
            pipe.sink(readData);
        }
        EXPECT_TRUE(false);
    }
    catch(const StreamEOFError& e)
    {
    }
    EXPECT_EQ("ABCD", string);
}


// Test the StreamTimeout class
TEST(streamTest, testTimeout1)
{
    std::string string;
    try
    {
        Pipe pipe(1024);

        {
            StreamTimeout timeout(pipe, 20000000);

            ReadMemory input1("ABCD", 4);
            pipe.feed(input1);

            ReadWriteMemory readData(4);
            pipe.sink(readData);
            size_t dataSize;
            char* data(readData.data(&dataSize));
            string += std::string(data, dataSize);
        }
    }
    catch(const StreamEOFError& e)
    {
        EXPECT_TRUE(false);
    }
    EXPECT_EQ("ABCD", string);
}

} // namespace tests

} // namespace imebra

