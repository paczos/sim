/*
Copyright 2005 - 2017 by Paolo Brandoli/Binarno s.p.

Imebra is available for free under the GNU General Public License.

The full text of the license is available in the file license.rst
 in the project root folder.

If you do not want to be bound by the GPL terms (such as the requirement 
 that your application must also be GPL), you may purchase a commercial 
 license for Imebra from the Imebra’s website (http://imebra.com).
*/

/*! \file imageCodecImpl.h
    \brief Declaration of the base class used by the image codecs.

*/

#if !defined(imebraImageCodec_299706D7_4761_44a1_9F2D_8C38A7BD7AD5__INCLUDED_)
#define imebraImageCodec_299706D7_4761_44a1_9F2D_8C38A7BD7AD5__INCLUDED_

#include <stdexcept>
#include <memory>
#include "memoryImpl.h"
#include "../include/imebra/definitions.h"


namespace imebra
{

namespace implementation
{

// Classes used in the declaration
class streamReader;
class streamWriter;
class dataSet;
class image;

/// \namespace codecs
/// \brief This namespace is used to define the classes
///         that implement a codec and their helper
///         classes
///
///////////////////////////////////////////////////////////
namespace codecs
{

/// \addtogroup group_codecs Codecs
/// \brief The codecs can generate a dataSet structure
///         or an image from a stream or can write the
///         dataSet structure or an image into a stream.
///
/// @{

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
/// \brief This is the base class for all the Imebra
///         image codecs.
///
/// An image codec is used to decompress an image stored
///  in a DICOM dataset.
///
/// A call to the dataSet::getImage() method will
///  return the decompressed image embedded into the dicom
///  structure.
///
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
class imageCodec
{
public:

    virtual ~imageCodec();

	///////////////////////////////////////////////////////////
	/// \name Set/get the image in the dicom structure
	///
	///////////////////////////////////////////////////////////
	//@{

	/// \brief Get a decompressed image from a dicom structure.
	///
	/// This function is usually called by 
	///  dataSet::getImage(), which also manages the 
    ///  codec and the frame selection.
	///
	/// The decompressed image will be stored in a image
	///  object.
    /// Your application can choose the frame to decompress if
	///  a multiframe Dicom structure is available.
	///
	/// We suggest to use the dataSet::getImage()
	///  function instead of calling this function directly.
	/// dataSet::getImage() takes care of selecting
	///  the right tag's group and buffer's id. Infact,
	///  some dicom file formats span images in several groups,
	///  while others use sequence when saving multiple frames.
	///
	/// @param pSourceDataSet a pointer to the Dicom structure 
	///              where the requested image is embedded into
	/// @param pSourceStream a pointer to a stream containing
	///              the data to be parsed
	/// @param dataType the data type of the buffer from which
	///               the stream pSourceStream has been 
	///               obtained. The data type must be in DICOM
	///               format
	/// @return a pointer to the loaded image
	///
	///////////////////////////////////////////////////////////
    virtual std::shared_ptr<image> getImage(const dataSet& sourceDataSet, std::shared_ptr<streamReader> pSourceStream, tagVR_t dataType) const = 0;
	
	/// \brief Stores an image into stream.
	///
	/// The image is compressed using the specified transfer
	///  syntax and quality.
	///
	/// The application should call dataSet::setImage()
	///  instead of calling this function directly.
	///
	/// @param pDestStream the stream where the compressed 
	///                     image must be saved
	/// @param pSourceImage the image to be saved into the
	///                     stream
	/// @param transferSyntax the transfer syntax to use for
	///                     the compression
	/// @param imageQuality the quality to use for the 
	///                     compression. Please note that the
	///                     parameters bSubSampledX and
	///                     bSubSampledY override the settings
	///                     specified by this parameter
	/// @param dataType    the data type of the tag that will
	///                     contain the generated stream
	/// @param allocatedBits the number of bits per color
	///                     channel
	/// @param bSubSampledX true if the chrominance channels
	///                     must be subsampled horizontally,
	///                     false otherwise
	/// @param bSubSampledY true if the chrominance channels
	///                     must be subsampled vertically,
	///                     false otherwise
	/// @param bInterleaved true if the channels' information
	///                      must be interleaved, false if the
	///                      channels' information must be
	///                      flat (not interleaved)
	/// @param b2Complement true if the image contains 
	///                     2-complement data, false otherwise
	///
	///////////////////////////////////////////////////////////
	virtual void setImage(
		std::shared_ptr<streamWriter> pDestStream,
		std::shared_ptr<image> pSourceImage, 
        const std::string& transferSyntax,
        imageQuality_t imageQuality,
        tagVR_t dataType,
        std::uint32_t allocatedBits,
		bool bSubSampledX,
		bool bSubSampledY,
		bool bInterleaved,
        bool b2Complement) const = 0;

	//@}


	///////////////////////////////////////////////////////////
	/// \name Selection of the codec from a transfer syntax
	///
	///////////////////////////////////////////////////////////
	//@{

	/// \brief This function returns true if the codec can
	///        handle the requested DICOM transfer syntax.
	///
	/// @param transferSyntax the transfer syntax to check
	///                         for
	/// @return true if the transfer syntax specified in
	///         transferSyntax can be handled by the
	///         codec, false otherwise.
	///
	///////////////////////////////////////////////////////////
    virtual bool canHandleTransferSyntax(const std::string& transferSyntax) const = 0;

	/// \brief This function returns true if the codec 
	///         transfer syntax handled by the code has to be
	///         encapsulated
	///
	/// @param transferSyntax the transfer syntax to check
	///                         for
	/// @return true if the transfer syntax specified in
	///         transferSyntax has to be encapsulated
	///
	///////////////////////////////////////////////////////////
    virtual bool encapsulated(const std::string& transferSyntax) const = 0;

	//@}


	///////////////////////////////////////////////////////////
	/// \name Image's attributes from the transfer syntax.
	///
	///////////////////////////////////////////////////////////
	//@{

	/// \brief Suggest an optimal number of allocated bits for
	///        the specified transfer syntax and high bit.
	///
	/// @param transferSyntax the transfer syntax to use
	/// @param highBit        the high bit to use for the
	///                        suggestion
	/// @return the suggested number of allocated bits for the
	///          specified transfer syntax and high bit.
	///
	///////////////////////////////////////////////////////////
    virtual std::uint32_t suggestAllocatedBits(const std::string& transferSyntax, std::uint32_t highBit) const = 0;

	//@}

};


class channel
{
public:
	// Constructor
	///////////////////////////////////////////////////////////
    channel():
        m_samplingFactorX(1),
        m_samplingFactorY(1),
        m_width(0),
        m_height(0),
        m_pBuffer(0),
        m_bufferSize(0){}

    // Allocate the channel
    ///////////////////////////////////////////////////////////
    void allocate(std::uint32_t width, std::uint32_t height);

	// Sampling factor
	///////////////////////////////////////////////////////////
	std::uint32_t m_samplingFactorX;
	std::uint32_t m_samplingFactorY;

	// Channel's size in pixels
	///////////////////////////////////////////////////////////
	std::uint32_t m_width;
	std::uint32_t m_height;

	// Channel's buffer & size
	///////////////////////////////////////////////////////////
	std::int32_t* m_pBuffer;
	std::uint32_t m_bufferSize;

	std::shared_ptr<memory> m_memory;
};



/// @}

} // namespace codecs

} // namespace implementation

} // namespace imebra


#endif // !defined(imebraCodec_299706D7_4761_44a1_9F2D_8C38A7BD7AD5__INCLUDED_)
