/*
Copyright 2005 - 2017 by Paolo Brandoli/Binarno s.p.

Imebra is available for free under the GNU General Public License.

The full text of the license is available in the file license.rst
 in the project root folder.

If you do not want to be bound by the GPL terms (such as the requirement
 that your application must also be GPL), you may purchase a commercial
 license for Imebra from the Imebra’s website (http://imebra.com).
*/

#if !defined(imebraObjcReadingDataHandler__INCLUDED_)
#define imebraObjcReadingDataHandler__INCLUDED_

#import <Foundation/Foundation.h>

#ifndef __IMEBRA_OBJECTIVEC_BRIDGING__
namespace imebra
{
class ReadingDataHandler;
}
#endif


@class ImebraDate;
@class ImebraAge;

///
/// \brief ImebraReadingDataHandler allows reading the content of a Dicom
///        Tag.
///
/// ImebraReadingDataHandler is able to return the Tag's content as a string,
/// a number, a date/time or an age.
///
/// In order to obtain a ImebraReadingDataHandler object for a specific
/// ImebraTag stored in a ImebraDataSet, call
/// ImebraDataSet::getReadingDataHandler() or
/// ImebraTag::getReadingDataHandler().
///
/// ImebraReadingDataHandler keeps a reference to the buffer's memory:
/// the buffer's memory is never modified but only replaced by a new memory
/// area, therefore the ReadingDataHandler client does not need to worry about
/// other clients modifying the memory being read.
///
///////////////////////////////////////////////////////////////////////////////
@interface ImebraReadingDataHandler: NSObject

#ifndef __IMEBRA_OBJECTIVEC_BRIDGING__
{
    @public
    imebra::ReadingDataHandler* m_pReadingDataHandler;
}

    -(id)initWithImebraReadingDataHandler:(imebra::ReadingDataHandler*)pReadingDataHandler;
#endif

    -(void)dealloc;

    /// \brief Returns the number of elements in the tag's buffer handled by the
    ///        data handler.
    ///
    /// If the ImebraReadingDataHandler object is related to a buffer that contains
    /// strings then it returns the number of strings stored in the buffer.
    /// Multiple strings are separated by a separator char.
    ///
    ///////////////////////////////////////////////////////////////////////////////
    @property (readonly) unsigned int size;

    /// \brief Retrieve a buffer's value as signed long integer (32 bit).
    ///
    /// If the buffer's value cannot be converted to a signed long integer
    /// then set pError to ImebraDataHandlerConversionError.
    ///
    /// \param index the element number within the buffer. Must be smaller than
    ///        getSize()
    /// \param pError set to a NSError derived class in case of error
    /// \return the tag's value as a signed 32 bit integer
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(int) getSignedLong:(unsigned int)index error:(NSError**)pError
        __attribute__((swift_error(nonnull_error)));

    /// \brief Retrieve a buffer's value as an unsigned long integer (32 bit).
    ///
    /// If the buffer's value cannot be converted to a unsigned long integer
    /// then set pError to ImebraDataHandlerConversionError.
    ///
    /// \param index the element number within the buffer. Must be smaller than
    ///        getSize()
    /// \param pError set to a NSError derived class in case of error
    /// \return the tag's value as an unsigned 32 bit integer
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(unsigned int) getUnsignedLong:(unsigned int)index error:(NSError**)pError
        __attribute__((swift_error(nonnull_error)));

    /// \brief Retrieve a buffer's value as a double floating point value (64 bit).
    ///
    /// If the buffer's value cannot be converted to a double floating point
    /// then set pError to ImebraDataHandlerConversionError.
    ///
    /// \param index the element number within the buffer. Must be smaller than
    ///        getSize()
    /// \param pError set to a NSError derived class in case of error
    /// \return the tag's value as a double floating point value (64 bit)
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(double) getDouble:(unsigned int)index error:(NSError**)pError
        __attribute__((swift_error(nonnull_error)));

    /// \brief Retrieve a buffer's value as a string.
    ///
    /// If the buffer's value cannot be converted to a string
    /// then set pError to ImebraDataHandlerConversionError.
    ///
    /// \param index the element number within the buffer. Must be smaller than
    ///        getSize()
    /// \param pError set to a NSError derived class in case of error
    /// \return the tag's value as a string
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(NSString*) getString:(unsigned int)index error:(NSError**)pError;

    /// \brief Retrieve a buffer's value as date or time.
    ///
    /// If the buffer's value cannot be converted to a date or time
    /// then set pError to ImebraDataHandlerConversionError.
    ///
    /// \param index the element number within the buffer. Must be smaller than
    ///        getSize()
    /// \param pError set to a NSError derived class in case of error
    /// \return the tag's value as a date or time
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(ImebraDate*) getDate:(unsigned int)index error:(NSError**)pError;

    /// \brief Retrieve a buffer's value as an age.
    ///
    /// If the buffer's value cannot be converted to an age
    /// then set pError to ImebraDataHandlerConversionError.
    ///
    /// \param index the element number within the buffer. Must be smaller than
    ///        getSize()
    /// \param pError set to a NSError derived class in case of error
    /// \return the tag's value as an Age
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(ImebraAge*) getAge:(unsigned int)index error:(NSError**)pError;


@end

#endif // !defined(imebraObjcReadingDataHandler__INCLUDED_)
