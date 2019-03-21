/*
Copyright 2005 - 2017 by Paolo Brandoli/Binarno s.p.

Imebra is available for free under the GNU General Public License.

The full text of the license is available in the file license.rst
 in the project root folder.

If you do not want to be bound by the GPL terms (such as the requirement
 that your application must also be GPL), you may purchase a commercial
 license for Imebra from the Imebra’s website (http://imebra.com).
*/

#if !defined(imebraObjcReadMemory__INCLUDED_)
#define imebraObjcReadMemory__INCLUDED_

#import <Foundation/Foundation.h>

#ifndef __IMEBRA_OBJECTIVEC_BRIDGING__
namespace imebra
{
class ReadMemory;
}
#endif

///
/// \brief Manages a read-only buffer of memory.
///
/// The buffer of memory is usually associated with a ImebraTag buffer content.
///
/// The memory used by ImebraReadMemory and ImebraReadWriteMemory is managed
/// by ImebraMemoryPool.
///
///////////////////////////////////////////////////////////////////////////////
@interface ImebraReadMemory: NSObject

#ifndef __IMEBRA_OBJECTIVEC_BRIDGING__
{
    @public
    imebra::ReadMemory* m_pMemory;
}

    -(id)initWithImebraReadMemory:(imebra::ReadMemory*)pReadMemory;
#endif

    -(id)init;

    /// \brief Construct a buffer of memory and copy the specified content into it.
    ///
    /// \param source a pointer to the source data
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(id)initWithData:(NSData*)source;

    /// \brief Copies the raw memory content into a NSData object and returns it.
    ///
    /// \return a NSData containing a copy of the memory managed by
    ///         ImebraReadMemory
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(NSData*)data;

    -(void)dealloc;

    /// \brief Return true if the referenced memory is zero bytes long or hasn't
    ///        been allocated yet.
    ///
    ///////////////////////////////////////////////////////////////////////////////
    @property (readonly) bool empty;

@end

#endif // !defined(imebraObjcReadMemory__INCLUDED_)
