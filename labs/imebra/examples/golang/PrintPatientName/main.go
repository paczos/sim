package main

import (
	"fmt"
	"imebra"
	"os"
)

func main() {

	fmt.Println("Display the patient name")

	if(len(os.Args) < 2) {
		fmt.Println("Usage: printPatientName dicomFileName")
		return
	}

	// Load the dataset specified in the parameter
	var dataset = imebra.CodecFactoryLoad(os.Args[1], int64(1024))

	// Get the first image
	var image = dataset.GetImage(0)

	// Get the patient name
	var patientName = dataset.GetString(imebra.NewTagId(imebra.TagId_t_PatientName_0010_0010), int64(0))

	// Print the patient name
	fmt.Println("Patient name: " + patientName)

	// Print the image color space
	fmt.Println("Image color space: " + image.GetColorSpace())
}
