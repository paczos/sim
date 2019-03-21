# Install script for directory: /home/sim/Documents/sim/imebra

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/doc/libimebra1" TYPE FILE PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ FILES "/home/sim/Documents/sim/imebra_compiled/artifacts/copyright")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libimebra.so.1.0.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libimebra.so.1"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libimebra.so"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHECK
           FILE "${file}"
           RPATH "")
    endif()
  endforeach()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/home/sim/Documents/sim/imebra_compiled/artifacts/libimebra.so.1.0.0"
    "/home/sim/Documents/sim/imebra_compiled/artifacts/libimebra.so.1"
    "/home/sim/Documents/sim/imebra_compiled/artifacts/libimebra.so"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libimebra.so.1.0.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libimebra.so.1"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libimebra.so"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/usr/bin/strip" "${file}")
      endif()
    endif()
  endforeach()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xInclude filesx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/imebra" TYPE FILE FILES
    "/home/sim/Documents/sim/imebra/library/include/imebra/VOILUT.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/acse.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/baseStreamInput.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/baseStreamOutput.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/codecFactory.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/colorTransformsFactory.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/dataSet.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/definitions.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/dicomDictionary.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/dicomDir.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/dicomDirEntry.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/dimse.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/drawBitmap.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/exceptions.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/fileStreamInput.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/fileStreamOutput.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/image.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/imebra.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/lut.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/memoryPool.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/memoryStreamInput.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/memoryStreamOutput.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/modalityVOILUT.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/pipe.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/readMemory.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/readWriteMemory.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/readingDataHandler.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/readingDataHandlerNumeric.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/streamReader.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/streamWriter.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/tag.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/tagId.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/tagsEnumeration.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/tcpAddress.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/tcpListener.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/tcpStream.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/transform.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/transformHighBit.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/transformsChain.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/uidsEnumeration.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/writingDataHandler.h"
    "/home/sim/Documents/sim/imebra/library/include/imebra/writingDataHandlerNumeric.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/sim/Documents/sim/imebra_compiled/artifacts/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
