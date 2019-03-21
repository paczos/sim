package main

import (
	"fmt"
	"imebra"
	"os"
	"strconv"
)

func main() {

	fmt.Println("Convert to jpeg")

	if(len(os.Args) < 3) {
		fmt.Println("Usage: printPatientName dicomFileName jpegFileName")
		return
	}

	imebra.CodecFactorySetMaximumImageSize(8000, 8000)

	// Load the dataset specified in the parameter
	//////////////////////////////////////////////
	var dataset = imebra.CodecFactoryLoad(os.Args[1], int64(1024))

	// Get the first image. We use it in case there isn't any presentation VOI/LUT
	//  and we have to calculate the optimal one
	//////////////////////////////////////////////////////////////////////////////
	var firstImage = dataset.GetImageApplyModalityTransform(0)
	var width = firstImage.GetWidth()
	var height = firstImage.GetHeight()

	// Build the transforms chain
	/////////////////////////////
	var transformsChain = imebra.NewTransformsChain()

	if(imebra.ColorTransformsFactoryIsMonochrome(firstImage.GetColorSpace())) {
		var presentationVOILUT = imebra.NewVOILUT()
		var vois = dataset.GetVOIs()

		if(!vois.IsEmpty()) {
			presentationVOILUT.SetCenterWidth(vois.Get(0).GetCenter(), vois.Get(0).GetWidth())
		} else {
			// Now find the optimal VOILUT
			//////////////////////////////
			presentationVOILUT.ApplyOptimalVOI(firstImage, 0, 0, width, height)
		}

		transformsChain.AddTransform(presentationVOILUT)
	}

	// Get the colorspace of the transformation output
	//////////////////////////////////////////////////
	var initialColorSpace = firstImage.GetColorSpace()
	if(!transformsChain.IsEmpty()) {
		var transformedImage = transformsChain.AllocateOutputImage(firstImage, 1, 1)
		initialColorSpace = transformedImage.GetColorSpace()
	}

	// Color transform to YCrCb
	///////////////////////////
	if(initialColorSpace != "YBR_FULL") {
		var colorTransform = imebra.ColorTransformsFactoryGetTransform(initialColorSpace, "YBR_FULL")
		if(!colorTransform.IsEmpty()) {
			transformsChain.AddTransform(colorTransform)
		}
	}

	// Tell the chain transform to allocate the output image:
	// if it has an high-bit different from 7 then we need to add
	//  a TransformHighBit.
	/////////////////////////////////////////////////////////////
	var testBitImage = transformsChain.AllocateOutputImage(firstImage, 1, 1);
	if(testBitImage.GetHighBit() > 7) {
		transformsChain.AddTransform(imebra.NewTransformHighBit());
	}

	// Allocate the image used to build the jpeg file
	/////////////////////////////////////////////////
	var ybr8Image = imebra.NewImage(width, height, imebra.BitDepth_t_depthU8, "YBR_FULL", 7);

	// Scan through the frames
	//////////////////////////
	var numberOfFrames = dataset.GetUnsignedLong(imebra.NewTagId(imebra.TagId_t_NumberOfFrames_0028_0008), int64(0), uint(1))
	for frame := uint(0); frame != numberOfFrames; frame++{

		// Get the frame with modality transform applied
		////////////////////////////////////////////////
		var image = dataset.GetImageApplyModalityTransform(int64(frame))

		// Apply VOI/LUT, color transform to YBR
		////////////////////////////////////////
		if transformsChain.IsEmpty(){
			ybr8Image = image
		} else{
			transformsChain.RunTransform(image, 0, 0, width, height, ybr8Image, 0, 0)
		}

		// Write jpeg
		/////////////
		var outputFileName = os.Args[2]
		if(numberOfFrames > 1) {
			outputFileName += "." + strconv.Itoa(int(frame))
		}
		var outputFile = imebra.NewFileStreamOutput(outputFileName)
		var outputStream = imebra.NewStreamWriter(outputFile)

		imebra.CodecFactorySaveImage(
		outputStream, ybr8Image,
		"1.2.840.10008.1.2.4.50", imebra.ImageQuality_t_veryHigh, imebra.TagVR_t_OB, 8, false, false, true, false)
	}

}
