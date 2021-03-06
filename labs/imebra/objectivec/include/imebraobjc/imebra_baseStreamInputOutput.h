/*
Copyright 2005 - 2017 by Paolo Brandoli/Binarno s.p.

Imebra is available for free under the GNU General Public License.

The full text of the license is available in the file license.rst
 in the project root folder.

If you do not want to be bound by the GPL terms (such as the requirement
 that your application must also be GPL), you may purchase a commercial
 license for Imebra from the Imebra’s website (http://imebra.com).
*/

#if !defined(imebraObjcBaseStreamInputOutput__INCLUDED_)
#define imebraObjcBaseStreamInputOutput__INCLUDED_

#import <Foundation/Foundation.h>
#import "imebra_baseStreamInput.h"

///
/// \brief Base class for stream that can act as both input and output
///        streams (e.g. ImebraTcpStream and ImebraPipe).
///
///////////////////////////////////////////////////////////////////////////////
@interface ImebraBaseStreamInputOutput: ImebraBaseStreamInput

@end

#endif // !defined(imebraObjcBaseStreamInputOutput__INCLUDED_)
