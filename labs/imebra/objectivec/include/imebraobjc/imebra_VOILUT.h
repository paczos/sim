/*
Copyright 2005 - 2017 by Paolo Brandoli/Binarno s.p.

Imebra is available for free under the GNU General Public License.

The full text of the license is available in the file license.rst
 in the project root folder.

If you do not want to be bound by the GPL terms (such as the requirement
 that your application must also be GPL), you may purchase a commercial
 license for Imebra from the Imebra’s website (http://imebra.com).
*/

#if !defined(imebraObjcVOILUT__INCLUDED_)
#define imebraObjcVOILUT__INCLUDED_

#import "imebra_transform.h"

@class ImebraImage;
@class ImebraLUT;


///
/// \brief A VOILUT transform enhances the visibility of a specific range of
///        brightness in an image.
///
/// The client can use VOILUT in three ways:
/// - by declaring the minimum and maximum values of the pixels that must be
///   visible via the method setCenterWidth()
/// - by declaring a LUT via the method setLUT()
/// - by letting the transform calculate the most appropriate center/width
///   values via the method applyOptimalVOI()
///
/// ImebraDataSet may already supply suitable values for the methods
/// setCenterWidth() and setLUT().
///
/// In order to retrieve from the dataset the suggested center/width values,
/// call ImebraDataSet::getVOIs().
///
/// To get from the dataset a list of LUTs that can be used with the VOILUT
/// transform use
/// ImebraDataSet::getLUT(TagId(ImebraTagId_t::ImebraVOILUTSequence_0028_3010), X)
/// where X is a 0 base index (the dataset may provide more than one LUT for
/// the VOILUT transform).
///
///////////////////////////////////////////////////////////////////////////////
@interface ImebraVOILUT: ImebraTransform

    /// \brief Initializer.
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(id)init;

    /// \brief Find the optimal VOI settings for a specific image's area and apply
    ///        it with setCenterWidth().
    ///
    /// \param pInputImage  the image to analyze
    /// \param topLeftX     the horizontal coordinate of the top-left angle of the
    ///                     area to analyze
    /// \param topLeftY     the vertical coordinate of the top-left angle of the
    ///                     area to analyze
    /// \param width        the width of the area to analyze
    /// \param height       the height of the area to analyze
    /// \param pError       set to a NSError derived class in case of error
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(void)applyOptimalVOI:
        (ImebraImage*)pInputImage
        inputTopLeftX:(unsigned int)inputTopLeftX
        inputTopLeftY:(unsigned int)inputTopLeftY
        inputWidth:(unsigned int)inputWidth
        inputHeight:(unsigned int)inputHeight
        error:(NSError**)pError

        __attribute__((swift_error(nonnull_error)));

    /// \brief Set the VOI settings applied by the transform.
    ///
    /// \param center the VOI center
    /// \param width  the VOI width
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(void)setCenter:(double)center width:(double)width;

    /// \brief Set the LUT that will be used by the transform to enhance the
    ///        contrast.
    ///
    /// The LUTs to be used for the VOILUT transform are stored in the dataset's
    /// sequence ImebraTagId_t::ImebraVOILUTSequence_0028_3010
    /// (group 0x0028, tag 0x3010).
    /// Each item in the sequence stores a single LUT.
    ///
    /// Use ImebraDataSet::getLUT() to retrieve the LUT from the DataSet.
    ///
    /// \param pLut  the LUT to apply
    ///
    ///////////////////////////////////////////////////////////////////////////////
    -(void)setLUT:(ImebraLUT*)pLUT;

    /// \brief Retrieve the VOI center applied by the transform.
    ///
    ///////////////////////////////////////////////////////////////////////////////
    @property (readonly) double center;

    /// \brief Retrieve the VOI width applied by the transform.
    ///
    ///////////////////////////////////////////////////////////////////////////////
    @property (readonly) double width;

@end


#endif // imebraObjcVOILUT__INCLUDED_
