/*
Copyright 2005 - 2017 by Paolo Brandoli/Binarno s.p.

Imebra is available for free under the GNU General Public License.

The full text of the license is available in the file license.rst
 in the project root folder.

If you do not want to be bound by the GPL terms (such as the requirement
 that your application must also be GPL), you may purchase a commercial
 license for Imebra from the Imebra’s website (http://imebra.com).
*/

#if !defined(imebraObjcTcpStream__INCLUDED_)
#define imebraObjcTcpStream__INCLUDED_

#import <Foundation/Foundation.h>
#import "imebra_baseStreamInputOutput.h"

#ifndef __IMEBRA_OBJECTIVEC_BRIDGING__
namespace imebra
{
class TCPStream;
}
#endif

@class ImebraTCPActiveAddress;
@class ImebraTCPAddress;


///
/// \brief Represents a TCP stream.
///
///////////////////////////////////////////////////////////////////////////////
@interface ImebraTCPStream: ImebraBaseStreamInputOutput

#ifndef __IMEBRA_OBJECTIVEC_BRIDGING__

    -(id)initWithImebraTcpStream:(imebra::TCPStream*)pTcpStream;

#endif

    ///
    /// \brief Construct a TCP socket and connects it to the destination address.
    ///
    /// This is a non-blocking operation (the connection proceed after the
    /// constructor returns). Connection errors will be reported later while
    /// the communication happens.
    ///
    /// \param pAddress the address to which the socket has to be connected.
    /// \param pError   set to a StreamError derived class in case of error
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(id)initWithAddress:(ImebraTCPActiveAddress*)pAddress error:(NSError**)pError;

    ///
    /// \brief Returns the address of the connected peer.
    ///
    /// \param pError   set to a StreamError derived class in case of error
    /// \return the address of the connected peer
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(ImebraTCPAddress*) getPeerAddress: (NSError**)pError;

    ///
    /// \brief Instruct any pending operation to terminate.
    ///
    /// Current and subsequent read and write operations will fail by setting
    /// pError to StreamClosedError.
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(void) terminate;


@end


#endif // imebraObjcTcpStream__INCLUDED_
