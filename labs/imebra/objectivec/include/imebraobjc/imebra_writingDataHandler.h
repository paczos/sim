/*
Copyright 2005 - 2017 by Paolo Brandoli/Binarno s.p.

Imebra is available for free under the GNU General Public License.

The full text of the license is available in the file license.rst
 in the project root folder.

If you do not want to be bound by the GPL terms (such as the requirement
 that your application must also be GPL), you may purchase a commercial
 license for Imebra from the Imebra’s website (http://imebra.com).
*/

#if !defined(imebraObjcWritingDataHandler__INCLUDED_)
#define imebraObjcWritingDataHandler__INCLUDED_

#import <Foundation/Foundation.h>

@class ImebraDate;
@class ImebraAge;


///
/// \brief ImebraWritingDataHandler allows to write the content
///        of a Dicom tag's buffer.
///
/// ImebraWritingDataHandler is able to write strings, numbers, date/time or
/// ages.
///
/// In order to obtain a ImebraWritingDataHandler object for a specific tag
/// call ImebraDataSet::getWritingDataHandler() or
/// ImebraTag::getWritingDataHandler().
///
/// The ImebraWritingDataHandler object always works on a new and clean
/// memory area.
/// Once the data has been written into the data handler then call commit()
/// in order to commit the data.
/// The data is committed also when the data handler is deallocated.
///
/// Once the data has been committed then the data handler does not respond
/// to further data modifications.
///
///////////////////////////////////////////////////////////////////////////////
@interface ImebraWritingDataHandler: NSObject
{
    @public
    void* m_pWritingDataHandlerVoidPointer;
}

    -(id)initWithImebraWritingDataHandler:(void*)pWritingDataHandler;

    -(void)dealloc;

    /// \brief Resize the memory to contain the specified number of elements
    ///        or return the current number of elements when read.
    ///
    /// By default, ImebraWritingDataHandler allocates an empty memory block
    /// that must be resized in order to be filled with data.
    ///
    ///////////////////////////////////////////////////////////////////////////////
    @property unsigned int size;

    /// \brief Write a signed long integer (32 bit).
    ///
    /// If the value cannot be converted from a signed long integer
    /// then set pError to ImebraDataHandlerConversionError.
    ///
    /// \param index the element number within the buffer. Must be smaller than
    ///        size()
    /// \param value the value to write
    /// \param pError set to a NSError derived class in case of error
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(void) setSignedLong:(unsigned int)index newValue:(int)value error:(NSError**)pError
        __attribute__((swift_error(nonnull_error)));

    /// \brief Write an unsigned long integer (32 bit).
    ///
    /// If the value cannot be converted from an unsigned long integer
    /// then set pError to ImebraDataHandlerConversionError.
    ///
    /// \param index the element number within the buffer. Must be smaller than
    ///        size()
    /// \param value the value to write
    /// \param pError set to a NSError derived class in case of error
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(void) setUnsignedLong:(unsigned int)index newValue:(unsigned int)value error:(NSError**)pError
        __attribute__((swift_error(nonnull_error)));

    /// \brief Write a double floating point value (64 bit).
    ///
    /// If the value cannot be converted from a double floating point
    /// then set pError to ImebraDataHandlerConversionError.
    ///
    /// \param index the element number within the buffer. Must be smaller than
    ///        size()
    /// \param value the value to write
    /// \param pError set to a NSError derived class in case of error
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(void) setDouble:(unsigned int)index newValue:(double)value error:(NSError**)pError
        __attribute__((swift_error(nonnull_error)));

    /// \brief Write a string.
    ///
    /// If the value cannot be converted from a string
    /// then set pError to ImebraDataHandlerConversionError.
    ///
    /// \param index the element number within the buffer. Must be smaller than
    ///        size()
    /// \param value the value to write
    /// \param pError set to a NSError derived class in case of error
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(void) setString:(unsigned int)index newValue:(NSString*)value error:(NSError**)pError
        __attribute__((swift_error(nonnull_error)));

    /// \brief Write a date and/or a time.
    ///
    /// If the value cannot be converted from a Date
    /// then set pError to ImebraDataHandlerConversionError.
    ///
    /// \param index the element number within the buffer. Must be smaller than
    ///        size()
    /// \param value the value to write
    /// \param pError set to a NSError derived class in case of error
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(void) setDate:(unsigned int)index newValue:(ImebraDate*)value error:(NSError**)pError
        __attribute__((swift_error(nonnull_error)));

    /// \brief Write an Age value.
    ///
    /// If the value cannot be converted from an Age
    /// then set pError to ImebraDataHandlerConversionError.
    ///
    /// \param index the element number within the buffer. Must be smaller than
    ///        size()
    /// \param value the value to write
    /// \param pError set to a NSError derived class in case of error
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(void) setAge:(unsigned int)index newValue:(ImebraAge*)value error:(NSError**)pError
        __attribute__((swift_error(nonnull_error)));

    /// \brief Commit the changes to the handler's memory.
    ///
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(void) commit;

@end

#endif // !defined(imebraObjcWritingDataHandler__INCLUDED_)
