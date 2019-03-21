package main

import (
	"fmt"
	"imebra"
	"os"
)


func main() {

	fmt.Println("C-MOVE")

	if(len(os.Args) < 9) {
		fmt.Println("Usage: cmove ourAET serverAET destinationAET ourPort serverAddress serverPort instanceUID classUID")
		return
	}


	var ourAET = os.Args[1]
	var serverAET = os.Args[2]
	var destinationAET = os.Args[3]
	var ourPort = os.Args[4]
	var serverAddress = os.Args[5]
	var serverPort = os.Args[6]
	var instanceUID = os.Args[7]
	var classUID = os.Args[8]

	var passiveAddress = imebra.NewTCPPassiveAddress("", ourPort)
	var tcpListener = imebra.NewTCPListener(passiveAddress)

	defer func() {
		r := recover()
		if r != nil {
			fmt.Println(r)
		}
	} ()

	go func() {
		defer func() {
			r := recover()
			if r != nil {
				fmt.Println(r)
			}
		} ()

		// Wait for an incoming connection. Will throw if the listener is closed
		// before a connection arrives
		var tcpStream = tcpListener.WaitForConnection()

		// Allocate a reader and a writer that read and write into the TCP stream
		var readScp = imebra.NewStreamReader(tcpStream)
		var writeScp = imebra.NewStreamWriter(tcpStream)

		// Tell that we accept the class UID specified in the command line, and which
		// transfer syntaxes we can handle for that class
		var context = imebra.NewPresentationContext(classUID)
		context.AddTransferSyntax("1.2.840.10008.1.2")
		context.AddTransferSyntax("1.2.840.10008.1.2.1")
		context.AddTransferSyntax("1.2.840.10008.1.2.4.50")
		context.AddTransferSyntax("1.2.840.10008.1.2.4.51")
		context.AddTransferSyntax("1.2.840.10008.1.2.4.57")
		context.AddTransferSyntax("1.2.840.10008.1.2.4.70")
		var presentationContexts = imebra.NewPresentationContexts()
		presentationContexts.AddPresentationContext(context)

		// Negotiate the association with the SCU (we act as SCP here)
		var scp = imebra.NewAssociationSCP(ourAET,
			1,
			1,
			presentationContexts,
			readScp,
			writeScp,
			30,
			30)

		// Use a DIMSE service to send and receive commands/response
		var scpDimseService = imebra.NewDimseService(scp)

		// We wait for just one command
		var command = scpDimseService.GetCommand()

		if(command.GetCommandType() == imebra.DimseCommandType_t_cStore) {
			// We received a cstore. Save the image
			var cstore = command.GetAsCStoreCommand()
			var dataSet = cstore.GetPayloadDataSet()
			imebra.CodecFactorySave(instanceUID, dataSet, imebra.CodecType_t_dicom)
			scpDimseService.SendCommandOrResponse(imebra.NewCStoreResponse(cstore, imebra.DimseStatusCode_t_success))
		} else {
			scp.Abort()
		}
	}()

	// Connect to the PACS
	var activeAddress = imebra.NewTCPActiveAddress(serverAddress, serverPort)
	var tcpStream = imebra.NewTCPStream(activeAddress)

	// Allocate a reader and a writer that read and write into the TCP stream
	var readScu = imebra.NewStreamReader(tcpStream)
	var writeScu = imebra.NewStreamWriter(tcpStream)

	// Tell that we want to use C-MOVE
	var context = imebra.NewPresentationContext("1.2.840.10008.5.1.4.1.2.1.2")
	context.AddTransferSyntax("1.2.840.10008.1.2")
	var presentationContexts = imebra.NewPresentationContexts()
	presentationContexts.AddPresentationContext(context)

	// Negotiate the association with the SCP
	var scu = imebra.NewAssociationSCU(ourAET,
		serverAET,
		1,
		1,
		presentationContexts,
		readScu,
		writeScu,
		10)

	// Use a DIMSE service to send and receive commands/response
	var scuDimseService = imebra.NewDimseService(scu)

	// Create a datase where we set the matching tags used to find the instances to move
	var identifierDataset = imebra.NewDataSet("1.2.840.10008.1.2")
	identifierDataset.SetString(imebra.NewTagId(imebra.TagId_t_MediaStorageSOPInstanceUID_0002_0003), instanceUID)

	// Prepare a C-MOVE command and send it to the SCP
	var moveCommand = imebra.NewCMoveCommand("1.2.840.10008.5.1.4.1.2.1.2",
		scuDimseService.GetNextCommandID(),
		imebra.DimseCommandPriority_t_medium,
		classUID,
		destinationAET,
		identifierDataset)

	scuDimseService.SendCommandOrResponse(moveCommand)

	// Wait for a response to the C-MOVE command
	var moveResponse = scuDimseService.GetCMoveResponse(moveCommand)
	if(moveResponse.GetStatus() == imebra.DimseStatus_t_success) {
		fmt.Println("OK")
	} else {
		fmt.Println("Error")
	}

}
