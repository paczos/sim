%module (threads="1") imebra


#ifdef SWIGJAVA
	%include <arrays_java.i>
	%include <enums.swg>

	%apply(char *STRING, size_t LENGTH) { (const char *source, size_t sourceSize) };
	%apply(char *STRING, size_t LENGTH) { (char* destination, size_t destinationSize) };

        %rename(assign) operator=;
#endif
#ifdef SWIGPYTHON
	%include <cdata.i>
	%include <pybuffer.i>
	%pybuffer_mutable_binary(void *STRING, size_t LENGTH)
	%apply(void *STRING, size_t LENGTH) { (const char *source, size_t sourceSize) };
	%apply(void *STRING, size_t LENGTH) { (char* destination, size_t destinationSize) };

        %rename(assign) operator=;

#endif

#ifdef SWIGGO
	%include <cdata.i>
	%include <gostring.swg>

        %typemap(gotype) (char* destination, size_t destinationSize) %{[]byte%}

        %typemap(in) (char* destination, size_t destinationSize) {
         $1 = ($1_ltype)$input.array;
         $2 = $input.len;
        }
	%apply(void *STRING, size_t LENGTH) { (const char *source, size_t sourceSize) };

%insert(cgo_comment_typedefs) %{
#cgo LDFLAGS: -limebra
%}

#endif

#define IMEBRA_API

%{

#include <imebra/imebra.h>

%}

%include <stl.i>
%include <std_string.i>

%include <exception.i>
%include <stdint.i>
%include <std_common.i>
%include <std_except.i>
%include <std_vector.i>
%include <std_map.i>


%template(FileParts) std::vector<std::string>;
%template(Groups) std::vector<std::uint16_t>;
%template(TagsIds) std::vector<imebra::TagId>;
%template(VOIs) std::vector<imebra::VOIDescription>;

#ifdef SWIGPYTHON

%typemap(out) imebra::DimseCommand* imebra::DimseService::getCommand() {

    switch($1->getCommandType())
    {
    case imebra::dimseCommandType_t::cStore:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr($1), $descriptor(imebra::CStoreCommand*), $owner);
        break;
    case imebra::dimseCommandType_t::cMove:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr($1), $descriptor(imebra::CMoveCommand*), $owner);
        break;
    case imebra::dimseCommandType_t::cGet:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr($1), $descriptor(imebra::CGetCommand*), $owner);
        break;
    case imebra::dimseCommandType_t::cFind:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr($1), $descriptor(imebra::CFindCommand*), $owner);
        break;
    case imebra::dimseCommandType_t::cEcho:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr($1), $descriptor(imebra::CEchoCommand*), $owner);
        break;
    case imebra::dimseCommandType_t::cCancel:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr($1), $descriptor(imebra::CCancelCommand*), $owner);
        break;
    case imebra::dimseCommandType_t::nAction:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr($1), $descriptor(imebra::NActionCommand*), $owner);
        break;
    case imebra::dimseCommandType_t::nEventReport:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr($1), $descriptor(imebra::NEventReportCommand*), $owner);
        break;
    case imebra::dimseCommandType_t::nCreate:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr($1), $descriptor(imebra::NCreateCommand*), $owner);
        break;
    case imebra::dimseCommandType_t::nDelete:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr($1), $descriptor(imebra::NDeleteCommand*), $owner);
        break;
    case imebra::dimseCommandType_t::nSet:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr($1), $descriptor(imebra::NSetCommand*), $owner);
        break;
    case imebra::dimseCommandType_t::nGet:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr($1), $descriptor(imebra::NGetCommand*), $owner);
        break;
    default:
        throw std::logic_error("Corrupted data");
    }
}

#endif

#ifdef SWIGJAVA

%typemap(jni) imebra::DimseCommand* getCommand "jobject"
%typemap(jtype) imebra::DimseCommand* getCommand "DimseCommand"
%typemap(jstype) imebra::DimseCommand* getCommand "DimseCommand"
%typemap(javaout) imebra::DimseCommand* getCommand {
    return $jnicall;
  }

%define downcastDimseCommand(className)

{
    imebra::className* pDowncast = dynamic_cast<imebra::className*>($1);
    if(pDowncast != 0)
    {
        jclass clazz = jenv->FindClass("com/imebra/className");
        if (clazz) {
            jmethodID mid = jenv->GetMethodID(clazz, "<init>", "(JZ)V");
            if (mid) {
                jlong cptr = 0;
                *(imebra::className **)& cptr = pDowncast;
                $result = jenv->NewObject(clazz, mid, cptr, $owner);
            }
        }
    }
}

%enddef

%typemap(out) imebra::DimseCommand* {
    imebra::CStoreCommand* pStore = dynamic_cast<imebra::CStoreCommand*>($1);
    imebra::CMoveCommand* pMove = dynamic_cast<imebra::CMoveCommand*>($1);
    imebra::CGetCommand* pGet = dynamic_cast<imebra::CGetCommand*>($1);

    downcastDimseCommand(CStoreCommand);
    downcastDimseCommand(CMoveCommand);
    downcastDimseCommand(CGetCommand);
    downcastDimseCommand(CFindCommand);
    downcastDimseCommand(CEchoCommand);
    downcastDimseCommand(CCancelCommand);
    downcastDimseCommand(NActionCommand);
    downcastDimseCommand(NEventReportCommand);
    downcastDimseCommand(NCreateCommand);
    downcastDimseCommand(NDeleteCommand);
    downcastDimseCommand(NSetCommand);
    downcastDimseCommand(NGetCommand);

}

#endif

#ifdef SWIGGO

#endif

// Declare which methods return an object that should be
// managed by the client.
////////////////////////////////////////////////////////
%newobject imebra::CodecFactory::load;

%newobject imebra::ColorTransformsFactory::getTransform;

%newobject imebra::DataSet::getTag;
%newobject imebra::DataSet::getTagCreate;
%newobject imebra::DataSet::getImage;
%newobject imebra::DataSet::getImageApplyModalityTransform;
%newobject imebra::DataSet::getSequenceItem;
%newobject imebra::DataSet::getLUT;
%newobject imebra::DataSet::getReadingDataHandler;
%newobject imebra::DataSet::getWritingDataHandler;
%newobject imebra::DataSet::getReadingDataHandlerNumeric;
%newobject imebra::DataSet::getWritingDataHandlerNumeric;
%newobject imebra::DataSet::getReadingDataHandlerRaw;
%newobject imebra::DataSet::getWritingDataHandlerRaw;
%newobject imebra::DataSet::getAge;
%newobject imebra::DataSet::getDate;

%newobject imebra::DicomDir::getNewEntry;
%newobject imebra::DicomDir::getFirstRootEntry;
%newobject imebra::DicomDir::updateDataSet;

%newobject imebra::DicomDirEntry::getEntryDataSet;
%newobject imebra::DicomDirEntry::getNextEntry;
%newobject imebra::DicomDirEntry::getFirstChildEntry;

%newobject imebra::DrawBitmap::getBitmap;

%newobject imebra::Image::getReadingDataHandler;
%newobject imebra::Image::getWritingDataHandler;

%newobject imebra::LUT::getReadingDataHandler;
%newobject imebra::LUT::getReadingDataHandler;
%newobject imebra::LUT::getReadingDataHandler;
%newobject imebra::LUT::getReadingDataHandler;

%newobject imebra::ReadingDataHandlerNumeric::getMemory;

%newobject imebra::Tag::getReadingDataHandler;
%newobject imebra::Tag::getWritingDataHandler;
%newobject imebra::Tag::getReadingDataHandlerNumeric;
%newobject imebra::Tag::getReadingDataHandlerRaw;
%newobject imebra::Tag::getWritingDataHandlerNumeric;
%newobject imebra::Tag::getWritingDataHandlerRaw;
%newobject imebra::Tag::getStreamReader;
%newobject imebra::Tag::getStreamWriter;
%newobject imebra::Tag::getSequenceItem;

%newobject imebra::Transform::allocateOutputImage;

%newobject imebra::WritingDataHandlerNumeric::getMemory;

%newobject imebra::AssociationMessage::getCommand;
%newobject imebra::AssociationMessage::getPayload;

%newobject imebra::AssociationBase::getCommand;
%newobject imebra::AssociationBase::getResponse;

%newobject imebra::DimseCommandBase::getCommandDataSet;
%newobject imebra::DimseCommandBase::getPayloadDataSet;

%newobject imebra::DimseCommand::getAsCStoreCommand;
%newobject imebra::DimseCommand::getAsCMoveCommand;
%newobject imebra::DimseCommand::getAsCGetCommand;
%newobject imebra::DimseCommand::getAsCFindCommand;
%newobject imebra::DimseCommand::getAsCEchoCommand;
%newobject imebra::DimseCommand::getAsCCancelCommand;
%newobject imebra::DimseCommand::getAsNActionCommand;
%newobject imebra::DimseCommand::getAsNEventReportCommand;
%newobject imebra::DimseCommand::getAsNCreateCommand;
%newobject imebra::DimseCommand::getAsNDeleteCommand;
%newobject imebra::DimseCommand::getAsNSetCommand;
%newobject imebra::DimseCommand::getAsNGetCommand;

%newobject imebra::DimseService::getCommand;
%newobject imebra::DimseService::getCStoreResponse;
%newobject imebra::DimseService::getCGetResponse;
%newobject imebra::DimseService::getCMoveResponse;
%newobject imebra::DimseService::getCFindResponse;
%newobject imebra::DimseService::getCEchoResponse;
%newobject imebra::DimseService::getNEventReportResponse;
%newobject imebra::DimseService::getNGetResponse;
%newobject imebra::DimseService::getNSetResponse;
%newobject imebra::DimseService::getNActionResponse;
%newobject imebra::DimseService::getNCreateResponse;
%newobject imebra::DimseService::getNDeleteResponse;

%newobject imebra::TCPListener::waitForConnection;
%newobject imebra::TCPStream::getPeerAddress;
%newobject imebra::StreamReader::getVirtualStream;


%factory(imebra::DimseCommand* imebra::DimseService::getCommand, imebra::CStoreCommand, imebra::CMoveCommand);

%exception {
    try {
        $action
    } catch(const imebra::MissingDataElementError& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_IndexError, error.c_str());
    } catch(const imebra::LutError& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_RuntimeError, error.c_str());
    } catch(const imebra::StreamError& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_IOError, error.c_str());
    } catch(const imebra::DictionaryError& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_ValueError, error.c_str());
    } catch(const imebra::CharsetConversionError& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_RuntimeError, error.c_str());
    } catch(const imebra::CodecError& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_IOError, error.c_str());
    } catch(const imebra::DataHandlerError& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_ValueError, error.c_str());
    } catch(const imebra::DataSetError& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_ValueError, error.c_str());
    } catch(const imebra::DicomDirError& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_RuntimeError, error.c_str());
    } catch(const imebra::HuffmanError& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_IOError, error.c_str());
    } catch(const imebra::ImageError& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_ValueError, error.c_str());
    } catch(const imebra::TransformError& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_ValueError, error.c_str());
    } catch(const imebra::MemoryError& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_MemoryError, error.c_str());
    } catch(const std::bad_cast& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_TypeError, error.c_str());
    } catch(const std::runtime_error& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_RuntimeError, error.c_str());
    } catch(const std::exception& e) {
        std::string error(imebra::ExceptionsManager::getExceptionTrace());
        SWIG_exception(SWIG_RuntimeError, error.c_str());
    }
}


%include "../library/include/imebra/tagsEnumeration.h"
%include "../library/include/imebra/tagId.h"
%include "../library/include/imebra/definitions.h"
%include "../library/include/imebra/readMemory.h"
%include "../library/include/imebra/readWriteMemory.h"
%include "../library/include/imebra/memoryPool.h"
%include "../library/include/imebra/baseStreamInput.h"
%include "../library/include/imebra/baseStreamOutput.h"
%include "../library/include/imebra/streamReader.h"
%include "../library/include/imebra/streamWriter.h"
%include "../library/include/imebra/readingDataHandler.h"
%include "../library/include/imebra/readingDataHandlerNumeric.h"
%include "../library/include/imebra/writingDataHandler.h"
%include "../library/include/imebra/writingDataHandlerNumeric.h"
%include "../library/include/imebra/lut.h"
%include "../library/include/imebra/image.h"
%include "../library/include/imebra/tag.h"
%include "../library/include/imebra/dataSet.h"
%include "../library/include/imebra/codecFactory.h"
%include "../library/include/imebra/tcpAddress.h"
%include "../library/include/imebra/tcpListener.h"
%include "../library/include/imebra/tcpStream.h"
%include "../library/include/imebra/pipe.h"
%include "../library/include/imebra/transform.h"
%include "../library/include/imebra/transformHighBit.h"
%include "../library/include/imebra/transformsChain.h"
%include "../library/include/imebra/modalityVOILUT.h"
%include "../library/include/imebra/VOILUT.h"
%include "../library/include/imebra/colorTransformsFactory.h"
%include "../library/include/imebra/dicomDirEntry.h"
%include "../library/include/imebra/dicomDir.h"
%include "../library/include/imebra/dicomDictionary.h"
%include "../library/include/imebra/drawBitmap.h"
%include "../library/include/imebra/fileStreamInput.h"
%include "../library/include/imebra/fileStreamOutput.h"
%include "../library/include/imebra/memoryStreamInput.h"
%include "../library/include/imebra/memoryStreamOutput.h"
%include "../library/include/imebra/acse.h"
%include "../library/include/imebra/dimse.h"

%extend imebra::StreamWriter {
    StreamWriter(const imebra::TCPStream& stream)
    {
        return new imebra::StreamWriter(stream);
    }

    StreamWriter(const imebra::Pipe& stream)
    {
        return new imebra::StreamWriter(stream);
    }
};

