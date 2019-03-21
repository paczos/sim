#include <imebra/imebra.h>
#include <gtest/gtest.h>
#include <iostream>
#include <thread>

#if defined(_WIN32)
#pragma comment(lib, "Ws2_32.lib")
#include <Winsock2.h>
#include <WS2tcpip.h>
#else
#include <netdb.h>
#endif


namespace imebra
{

namespace tests
{

void sendDataThread(unsigned long maxConnections, std::string port)
{
    TCPActiveAddress connectToAddress("", port);

    try
    {
        for(unsigned int connectionNumber(0); connectionNumber != maxConnections; ++connectionNumber)
    {
        TCPStream newStream(connectToAddress);

        DataSet dataSet("1.2.840.10008.1.2.1");
        dataSet.setUnsignedLong(TagId(11, 11), connectionNumber, tagVR_t::UL);

        std::this_thread::sleep_for(std::chrono::seconds(5));

        StreamWriter writer(newStream);
        CodecFactory::save(dataSet, writer, codecType_t::dicom);
        }
    }
    catch(const std::exception& e)
    {
        std::cout << "Error in sending thread" << std::endl;
        std::cout << e.what() << std::endl;
        std::cout << imebra::ExceptionsManager::getExceptionTrace() << std::endl;
    }
}

TEST(tcpTest, sendReceive)
{
    const std::string listeningPort("20000");

    TCPPassiveAddress listeningAddress("", listeningPort);

    TCPListener listener(listeningAddress);

    unsigned long maxConnections(10);

    std::thread sendDataThread(imebra::tests::sendDataThread, maxConnections, listeningPort);

    try
    {
        for(unsigned int connectionNumber(0); connectionNumber != maxConnections; ++connectionNumber)
    {
        std::unique_ptr<TCPStream> newStream(listener.waitForConnection());

        StreamReader reader(*newStream);
        std::unique_ptr<DataSet> pDataSet(CodecFactory::load(reader));

        ASSERT_EQ(connectionNumber, pDataSet->getUnsignedLong(TagId(11, 11), 0));
        }
    }
    catch(const std::exception& e)
    {
        std::cout << "Error in sending sendreceive test" << std::endl;
        std::cout << e.what() << std::endl;
        std::cout << imebra::ExceptionsManager::getExceptionTrace() << std::endl;
        EXPECT_TRUE(false);
    }

    sendDataThread.join();
}

void AcceptConnectionAndCloseThread(std::string port)
{
    TCPPassiveAddress listeningAddress("", port);

    TCPListener listener(listeningAddress);

    std::unique_ptr<TCPStream> newStream(listener.waitForConnection());

}

TEST(tcpTest, prematureClose)
{
    const std::string listeningPort("20000");

    std::thread acceptConnectionAndCloseThread(imebra::tests::AcceptConnectionAndCloseThread, listeningPort);

    std::this_thread::sleep_for(std::chrono::seconds(5));

    TCPActiveAddress connectToAddress("", listeningPort);

    TCPStream newStream(connectToAddress);

    std::this_thread::sleep_for(std::chrono::seconds(5));

    DataSet dataSet("1.2.840.10008.1.2.1");
    dataSet.setUnsignedLong(TagId(11, 11), 1, tagVR_t::UL);

    StreamWriter writer(newStream);

    try
    {
        for(int iterations(0); iterations != 100; ++iterations)
        {
            CodecFactory::save(dataSet, writer, codecType_t::dicom);
        }
        EXPECT_TRUE(false);
    }
    catch(const StreamClosedError&)
    {
        EXPECT_TRUE(true);
    }
    catch(...)
    {
        EXPECT_TRUE(false);
    }

    acceptConnectionAndCloseThread.join();
}


TEST(tcpTest, refusedConnection)
{
    TCPActiveAddress connectToAddress("", "20000");

    TCPStream newStream(connectToAddress);

    std::this_thread::sleep_for(std::chrono::seconds(5));

    DataSet dataSet("1.2.840.10008.1.2.1");
    dataSet.setUnsignedLong(TagId(11, 11), 1, tagVR_t::UL);

    StreamWriter writer(newStream);

    try
    {
        CodecFactory::save(dataSet, writer, codecType_t::dicom);
        EXPECT_TRUE(false);
    }
    catch(const StreamClosedError&)
    {
        EXPECT_TRUE(true);
    }
    catch(const TCPConnectionRefused&)
    {
        EXPECT_TRUE(true);
    }
    catch(const StreamError& e)
    {
        std::cout << "Caught wrong exception: " << e.what();
        EXPECT_TRUE(false);
    }

}


void DelayConnectionThread(std::string port)
{
    TCPPassiveAddress listeningAddress("", port); // Force initialization of Winsock

    addrinfo hints;
    ::memset(&hints, 0, sizeof(hints));
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_family = AF_INET;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_flags = AI_PASSIVE;

    addrinfo* address(0);
    getaddrinfo(0, port.c_str(), &hints, &address);

    std::vector<std::uint8_t> sockAddr;
    sockAddr.resize(address->ai_addrlen);
    ::memcpy(&(sockAddr[0]), address->ai_addr, address->ai_addrlen);
    freeaddrinfo(address);

    int listeningSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

    bind(listeningSocket, (sockaddr*)sockAddr.data(), (socklen_t)sockAddr.size());
    listen(listeningSocket, SOMAXCONN);

    std::this_thread::sleep_for(std::chrono::seconds(10));

    sockaddr_in peeraddr;
    socklen_t peersockaddrLen(sizeof(peeraddr));
    int acceptedSocket = accept(listeningSocket, (sockaddr*)&peeraddr, &peersockaddrLen);

    char buffer[5];
    for(size_t totalReceivedBytes(0); totalReceivedBytes < 100; )
    {
        long receivedBytes((long)recv(listeningSocket, buffer, sizeof(buffer), 0));
        if(receivedBytes > 0)
        {
            totalReceivedBytes += (size_t)receivedBytes;
        }
        else
        {
            break;
        }
    }

    #ifdef _WIN32
            ::closesocket(acceptedSocket);
            ::closesocket(listeningSocket);
    #else
            ::close(acceptedSocket);
            ::close(listeningSocket);
    #endif

}


TEST(tcpTest, delayedConnection)
{
    const std::string listeningPort("20000");

    std::thread delayConnection(imebra::tests::DelayConnectionThread, listeningPort);

    std::this_thread::sleep_for(std::chrono::seconds(1));

    TCPActiveAddress connectToAddress("", listeningPort);

    TCPStream newStream(connectToAddress);

    std::this_thread::sleep_for(std::chrono::seconds(5));

    DataSet dataSet("1.2.840.10008.1.2.1");
    dataSet.setUnsignedLong(TagId(11, 11), 1, tagVR_t::UL);

    StreamWriter writer(newStream);

    CodecFactory::save(dataSet, writer, codecType_t::dicom);

    try
    {
        for(int iterations(0); iterations != 100000; ++iterations)
        {
            CodecFactory::save(dataSet, writer, codecType_t::dicom);
        }
        EXPECT_TRUE(false);
    }
    catch(const StreamClosedError&)
    {
        EXPECT_TRUE(true);
    }
    catch(std::runtime_error& e)
    {
        std::cout << "Caught wrong exception: " << e.what() << std::endl;
        EXPECT_TRUE(false);
    }

    delayConnection.join();
}


TEST(tcpTest, nonExistentAddress)
{
    EXPECT_THROW(TCPActiveAddress("gfsdgf.bbbgfdgfasd.netdasfsdf", "20000"), AddressError);
}



TEST(tcpTest, noService)
{
    EXPECT_THROW(TCPActiveAddress("localhost", "abcdzy"), AddressError);
}
} // namespace tests

} // namespace imebra
