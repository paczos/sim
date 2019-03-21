# Options:
# -DIMEBRA_SHARED_STATIC=SHARED|STATIC (default = SHARED)
# -DJPEG2000=0|1|2 include JPEG2000 codec (1=version 1.X 2=version2.X)
# -DADDITIONAL_INCLUDE_PATH=path to additional include folders (optional)
# -DADDITIONAL_LIB_PATH=path to additional libraries (optional)
# -DIMEBRA_CHARSET_CONVERSION=ICONV|ICU|JAVA|WINDOWS (default = ICONV on posix, WINDOWS on Windows)
# -DIMEBRA_OBJC=1|0 (default = 0)
# -DIOS=PHONE|SIMULATOR (default not defined)
# -DEMBED_BITCODE=1|0 (default = 0)
# -DCMAKE_OSX_SYSROOT

cmake_minimum_required(VERSION 2.8)

project("imebra")

set(CMAKE_CONFIGURATION_TYPES Debug Release)

set(imebra_libraries "")

# Select the proper charset conversion libraries according to the charset conversion method
#------------------------------------------------------------------------------------------
if(IMEBRA_CHARSET_CONVERSION MATCHES ICONV)
    message("Using ICONV")
    add_definitions(-DIMEBRA_USE_ICONV)
    if(APPLE)
        set(imebra_libraries ${imebra_libraries} iconv)
    endif(APPLE)
elseif(IMEBRA_CHARSET_CONVERSION MATCHES ICU)
    message("Using ICU")
    add_definitions(-DIMEBRA_USE_ICU)
    set(imebra_libraries ${imebra_libraries} icuuc)
    set(imebra_libraries ${imebra_libraries} icuio)
elseif(IMEBRA_CHARSET_CONVERSION MATCHES JAVA)
    message("Using JAVA")
    add_definitions(-DIMEBRA_USE_JAVA)
elseif(IMEBRA_CHARSET_CONVERSION MATCHES WINDOWS)
    message("Using WINDOWS CHARSET CONVERSION")
    add_definitions(-DIMEBRA_USE_WINDOWS_CHARSET)
else(IMEBRA_CHARSET_CONVERSION MATCHES ICONV)
    if(WIN32)
        message("Using WINDOWS CHARSET CONVERSION (default)")
        add_definitions(-DIMEBRA_USE_WINDOWS_CHARSET)
    else(WIN32)
        message("Using ICONV (default)")
        add_definitions(-DIMEBRA_USE_ICONV)
        if(APPLE)
            set(imebra_libraries ${imebra_libraries} iconv)
        endif(APPLE)
    endif(WIN32)
endif(IMEBRA_CHARSET_CONVERSION MATCHES ICONV)

# For IPhone build a static library, otherwise build a dynamic library
#---------------------------------------------------------------------
if(NOT DEFINED IMEBRA_SHARED_STATIC)
    set(IMEBRA_SHARED_STATIC "SHARED")
endif(NOT DEFINED IMEBRA_SHARED_STATIC)

if(APPLE)
    set(IMEBRA_OBJC 1)
    if(IOS)
        set(IMEBRA_SHARED_STATIC "STATIC")
        if("${IOS}" MATCHES "PHONE")
            exec_program(xcrun ARGS --sdk iphoneos --show-sdk-path OUTPUT_VARIABLE CMAKE_OSX_SYSROOT)
            set (CMAKE_OSX_ARCHITECTURES armv7 armv7s arm64)
        elseif("${IOS}" MATCHES "SIMULATOR")
            exec_program(xcrun ARGS --sdk iphonesimulator --show-sdk-path OUTPUT_VARIABLE CMAKE_OSX_SYSROOT)
            set (CMAKE_OSX_ARCHITECTURES i386 x86_64)
        else("${IOS}" MATCHES "PHONE")
            message (FATAL_ERROR "Set IOS to PHONE or SIMULATOR")
        endif("${IOS}" MATCHES "PHONE")
        message ("IOS SDK ROOT: ${CMAKE_OSX_SYSROOT}")
    endif(IOS)
endif(APPLE)


##############################################
#
# LIBRARY
#
##############################################
add_definitions(-DIMEBRA_DLL)
add_definitions(-DIMEBRA_DLL_EXPORTS)
add_definitions(-DNOMINMAX)

file(GLOB imebra_interface "${CMAKE_CURRENT_SOURCE_DIR}/library/include/imebra/*.h")
file(GLOB imebra_include "${CMAKE_CURRENT_SOURCE_DIR}/library/src/*.h")
file(GLOB imebra_src "${CMAKE_CURRENT_SOURCE_DIR}/library/src/*.cpp")
file(GLOB imebra_implementation_src "${CMAKE_CURRENT_SOURCE_DIR}/library/implementation/*.cpp")
file(GLOB imebra_implementation_include "${CMAKE_CURRENT_SOURCE_DIR}/library/implementation/*.h")
set(imebra_objc_src "")
set(imebra_objc_include "")
set(imebra_objc_include_dir "")
set(imebra_objc_gnustep_dir "")

if("${IMEBRA_OBJC}" STREQUAL "1")

    file(GLOB imebra_objc_src "${CMAKE_CURRENT_SOURCE_DIR}/objectivec/src/*.*")
    file(GLOB imebra_objc_include "${CMAKE_CURRENT_SOURCE_DIR}/objectivec/include/imebraobjc/*.h")
    add_definitions(-DIMEBRA_OBJC)

    set(imebra_objc_include_dirs ${CMAKE_CURRENT_SOURCE_DIR}/objectivec/include)

    set(objc_compiler_flags "")
    if(APPLE)
        set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -framework Foundation -framework CoreServices")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -framework Foundation -framework CoreServices")
        if(IOS)
            set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_STATIC_LINKER_FLAGS} -framework UIKit")
            set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -framework UIKit")
        else(IOS)
            set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_STATIC_LINKER_FLAGS} -framework AppKit")
            set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -framework AppKit")
        endif(IOS)
    else(APPLE)
        set(objc_compiler_flags "${objc_compiler_flags} -fconstant-string-class=NSConstantString")
        set(imebra_objc_gnustep_dir "/usr/include/GNUstep")
        set(imebra_libraries ${imebra_libraries} gnustep-base objc)
    endif(APPLE)

    if(NOT "${objc_compiler_flags}" STREQUAL "")

        foreach(objcfile ${imebra_objc_src})
            set_source_files_properties(${objcfile} PROPERTIES COMPILE_FLAGS ${objc_compiler_flags})
        endforeach(objcfile ${imebra_objc_src})

    endif(NOT "${objc_compiler_flags}" STREQUAL "")

endif("${IMEBRA_OBJC}" STREQUAL "1")


if(NOT "${ADDITIONAL_LIB_PATH}" STREQUAL "")
    link_directories(${LINK_DIRECTORIES} ${ADDITIONAL_LIB_PATH})
endif(NOT "${ADDITIONAL_LIB_PATH}" STREQUAL "")

# Add jpeg2000 if specified
if("${JPEG2000}" STREQUAL "1")
    set(imebra_libraries ${imebra_libraries} openjpeg)
    add_definitions(-DJPEG2000)
    add_definitions(-DJPEG2000_V1)
    message(STATUS "Adding experimental Jpeg2000 codec (based on OpenJpeg v1.X)")
endif("${JPEG2000}" STREQUAL "1")

if("${JPEG2000}" STREQUAL "2")
    set(imebra_libraries ${imebra_libraries} openjp2)
    add_definitions(-DJPEG2000)
    add_definitions(-DJPEG2000_V2)
    message(STATUS "Adding experimental Jpeg2000 codec (based on OpenJpeg v2.X)")
endif("${JPEG2000}" STREQUAL "2")

add_library(imebra ${IMEBRA_SHARED_STATIC}
    ${imebra_implementation_src}
    ${imebra_implementation_include}
    ${imebra_objc_src}
    ${imebra_objc_include}
    ${imebra_include}
    ${imebra_src}
    ${imebra_interface}
)

if(NOT "${ADDITIONAL_INCLUDE_PATH}" STREQUAL "")
    target_include_directories(imebra PRIVATE ${ADDITIONAL_INCLUDE_PATH})
endif(NOT "${ADDITIONAL_INCLUDE_PATH}" STREQUAL "")

if("${IMEBRA_OBJC}" STREQUAL "1")
    set(HIDDEN_FLAGS "")
else("${IMEBRA_OBJC}" STREQUAL "1")
    set(HIDDEN_FLAGS "-fvisibility=hidden -fvisibility-inlines-hidden")
endif("${IMEBRA_OBJC}" STREQUAL "1")


# Add flags specific to the compiler
#-----------------------------------
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")

    message(STATUS "GCC detected, adding compile flags")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall -Wextra -Wpedantic -Wconversion -Wfloat-equal ${HIDDEN_FLAGS}")
    set(imebra_libraries ${imebra_libraries} pthread)

    if(CMAKE_BUILD_TYPE MATCHES DEBUG)
        message("debug mode")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage")
        set(imebra_libraries ${imebra_libraries} gcov)
    endif(CMAKE_BUILD_TYPE MATCHES DEBUG)

elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")

    message(STATUS "CLANG detected, adding compile flags")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall -Wextra -Wpedantic -Wconversion -Wfloat-equal ${HIDDEN_FLAGS}")
    if("${EMBED_BITCODE}" STREQUAL "1")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fembed-bitcode")
    endif("${EMBED_BITCODE}" STREQUAL "1")
    set(imebra_libraries ${imebra_libraries} pthread)

elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")

    message(STATUS "MSVC detected, adding compile flags")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4 /Wp64")
    set(imebra_libraries ${imebra_libraries} Kernel32)

endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")

# Define dependency libraries
#----------------------------
target_link_libraries(imebra ${imebra_libraries})

message (STATUS "OBJC INCLUDE:${imebra_objc_include_dirs}")
message (STATUS "GNU INCLUDE:${imebra_objc_gnustep_dir}")

# Define Imebra public folder
#----------------------------
target_include_directories(imebra PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/library/include
                                  PUBLIC ${imebra_objc_include_dirs}
                                  PUBLIC ${imebra_objc_gnustep_dir})

# Set the library version from IMEBRA_MAJOR_VERSION, IMEBRA_MINOR_VERSION,
#  & IMEBRA_REVISION
#---------------------------------------------------------------------------------
if ("$ENV{IMEBRA_MAJOR_VERSION}" STREQUAL "")
    set(IMEBRA_MAJOR_VERSION "1")
else("$ENV{IMEBRA_MAJOR_VERSION}" STREQUAL "")
    set(IMEBRA_MAJOR_VERSION "$ENV{IMEBRA_MAJOR_VERSION}")
endif("$ENV{IMEBRA_MAJOR_VERSION}" STREQUAL "")

if ("$ENV{IMEBRA_MINOR_VERSION}" STREQUAL "")
    set(IMEBRA_MINOR_VERSION "0")
else("$ENV{IMEBRA_MINOR_VERSION}" STREQUAL "")
    set(IMEBRA_MINOR_VERSION "$ENV{IMEBRA_MINOR_VERSION}")
endif("$ENV{IMEBRA_MINOR_VERSION}" STREQUAL "")

if ("$ENV{IMEBRA_REVISION}" STREQUAL "")
    set(IMEBRA_REVISION "0")
else("$ENV{IMEBRA_REVISION}" STREQUAL "")
    set(IMEBRA_REVISION "$ENV{IMEBRA_REVISION}")
endif("$ENV{IMEBRA_REVISION}" STREQUAL "")

set(IMEBRA_VERSION "${IMEBRA_MAJOR_VERSION}.${IMEBRA_MINOR_VERSION}.${IMEBRA_REVISION}")

set_target_properties(imebra PROPERTIES VERSION ${IMEBRA_VERSION}
                                          SOVERSION ${IMEBRA_MAJOR_VERSION})


if(NOT IOS)

    ##############################################
    #
    # TESTS
    #
    ##############################################

    # We need thread support
    find_package(Threads REQUIRED)

    # Enable ExternalProject CMake module
    include(ExternalProject)

    # Download and install GoogleTest
    ExternalProject_Add(
        gtest
        URL https://github.com/google/googletest/archive/release-1.7.0.zip
            CMAKE_ARGS "-Dgtest_force_shared_crt=ON"
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/gtest
            INSTALL_COMMAND ""
    )

    # Get GTest source and binary directories from CMake project
    ExternalProject_Get_Property(gtest source_dir binary_dir)

    # Create a libgtest target to be used as a dependency by test programs
    add_library(libgtest IMPORTED STATIC GLOBAL)
    add_dependencies(libgtest gtest)


    # Set libgtest properties
    if(APPLE)
    set_target_properties(libgtest PROPERTIES
        "IMPORTED_LOCATION" "${binary_dir}/libgtest.a"
        "IMPORTED_LOCATION_DEBUG" "${binary_dir}/Debug/libgtest.a"
        "IMPORTED_LOCATION_RELEASE" "${binary_dir}/Release/libgtest.a"
        "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
    )
    elseif(MSVC)
    set_target_properties(libgtest PROPERTIES
        "IMPORTED_LOCATION" "${binary_dir}/gtest.lib"
        "IMPORTED_LOCATION_DEBUG" "${binary_dir}/Debug/gtest.lib"
        "IMPORTED_LOCATION_RELEASE" "${binary_dir}/Release/gtest.lib"
        "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
    )
    else(APPLE)
    set_target_properties(libgtest PROPERTIES
        "IMPORTED_LOCATION" "${binary_dir}/libgtest.a"
        "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
    )
    endif(APPLE)

    # Find DCMTK for interoperability tests.
    find_package(DCMTK)
    if(${DCMTK_FOUND})
            message(STATUS "DCMTK found. Interoperability tests enabled")
    else(${DCMTK_FOUND})
            add_definitions(-DDISABLE_DIMSE_INTEROPERABILITY_TEST)
            message(WARNING "WARNING: DCMTK not found. Disabling interoperability tests")
    endif(${DCMTK_FOUND})

    set(imebra_tests_objc_src "")

    file(GLOB imebra_tests_include "${CMAKE_CURRENT_SOURCE_DIR}/tests/*.h")
    file(GLOB imebra_tests_src "${CMAKE_CURRENT_SOURCE_DIR}/tests/*.cpp")
    if("${IMEBRA_OBJC}" STREQUAL "1")

        file(GLOB imebra_tests_objc_src "${CMAKE_CURRENT_SOURCE_DIR}/tests/objectivec/*.m*")

        if(NOT "${objc_compiler_flags}" STREQUAL "")

            foreach(objcfile ${imebra_tests_objc_src})
                set_source_files_properties(${objcfile} PROPERTIES COMPILE_FLAGS ${objc_compiler_flags})
            endforeach(objcfile ${imebra_objc_src})

        endif(NOT "${objc_compiler_flags}" STREQUAL "")

    endif("${IMEBRA_OBJC}" STREQUAL "1")

    add_executable(ImebraTests
            ${imebra_tests_include}
            ${imebra_tests_src}
            ${imebra_tests_objc_src}
    )
    target_include_directories(ImebraTests PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/gtest/src/gtest/include)
    target_link_libraries(ImebraTests imebra libgtest)


    ##############################################
    #
    # RUN TESTS
    #
    ##############################################
    enable_testing()

    add_test(RunImebraTests ImebraTests --corruptedFilesFolder=${CMAKE_CURRENT_SOURCE_DIR}/tests/corruptedfiles)


    ##############################################
    #
    # DICOM2JPEG example
    #
    ##############################################
    file(GLOB dicom2jpeg_sources "${CMAKE_CURRENT_SOURCE_DIR}/examples/c++/dicom2jpeg/*.cpp")

    # Add the source files to the project
    #------------------------------------
    add_executable(dicom2jpeg ${dicom2jpeg_sources})

    target_link_libraries(dicom2jpeg imebra)


    ##############################################
    #
    # CHANGETRANSFERSYNTAX example
    #
    ##############################################
    file(GLOB changeTransferSyntax_sources "${CMAKE_CURRENT_SOURCE_DIR}/examples/c++/changeTransferSyntax/*.cpp")

    # Add the source files to the project
    #------------------------------------
    add_executable(changeTransferSyntax ${changeTransferSyntax_sources})

    target_link_libraries(changeTransferSyntax imebra)


    ##############################################
    #
    # DICOMDIRITEMS example
    #
    ##############################################
    file(GLOB dicomdirItems_sources "${CMAKE_CURRENT_SOURCE_DIR}/examples/c++/dicomdirItems/*.cpp")

    # Add the source files to the project
    #------------------------------------
    add_executable(dicomDirItems ${dicomdirItems_sources})

    target_link_libraries(dicomDirItems imebra)




endif(NOT IOS)




##############################################
#
# PACKAGING
#
##############################################

# Set packaging variables
#------------------------
set(CPACK_PACKAGE_NAME "libimebra${IMEBRA_MAJOR_VERSION}")
set(CPACK_PACKAGE_CONTACT "paolo@binarno.com")
set(CPACK_PACKAGE_VERSION ${IMEBRA_VERSION})
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Imebra library for DICOM medical files")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/readme.rst")

set(CPACK_DEBIAN_PACKAGE_DEPENDS "libc6")
set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "https://imebra.com")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Paolo Brandoli <paolo@binarno.com>")
set(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
set(CPACK_DEBIAN_PACKAGE_SECTION "devel")

set(CPACK_RPM_PACKAGE_REQUIRES "libc6")

# Generate the control scripts
#-----------------------------
set(SHLIBS_FILE     "${CMAKE_CURRENT_BINARY_DIR}/shlibs")
set(POSTINST_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/postinst")
set(PRERM_SCRIPT    "${CMAKE_CURRENT_BINARY_DIR}/prerm")
set(POSTRM_SCRIPT   "${CMAKE_CURRENT_BINARY_DIR}/postrm")

# Generate postinst, prerm and postrm hooks
file(WRITE "${POSTINST_SCRIPT}" "#!/bin/sh\n\nset -e\n")
file(WRITE "${PRERM_SCRIPT}"    "#!/bin/sh\n\nset -e\n")
file(WRITE "${POSTRM_SCRIPT}"   "#!/bin/sh\n\nset -e\n")

# Generate shlibs
file(WRITE "${SHLIBS_FILE}" "libimebra ${IMEBRA_MAJOR_VERSION} ${CPACK_PACKAGE_NAME}\n")
file(APPEND "${POSTINST_SCRIPT}"
     "if [ \"$1\" = \"configure\" ]; then
        ldconfig
fi
")
file(APPEND "${POSTRM_SCRIPT}"
     "if [ \"$1\" = \"remove\" ]; then
        ldconfig
fi")

execute_process(COMMAND chmod 644 "${SHLIBS_FILE}")
execute_process(COMMAND chmod 755 "${POSTINST_SCRIPT}" "${PRERM_SCRIPT}" "${POSTRM_SCRIPT}")
set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${SHLIBS_FILE};${POSTINST_SCRIPT};${PRERM_SCRIPT};${POSTRM_SCRIPT}")

# Write license file
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/copyright"
     "Copyright (C) 2015 ${CPACK_DEBIAN_PACKAGE_MAINTAINER}")

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/copyright"
        DESTINATION "share/doc/${CPACK_PACKAGE_NAME}/"
        PERMISSIONS
        OWNER_WRITE OWNER_READ
        GROUP_READ
        WORLD_READ)

install(TARGETS imebra LIBRARY DESTINATION lib
                                                ARCHIVE DESTINATION lib
                                                LIBRARY DESTINATION lib
                                                RUNTIME DESTINATION bin
                                                COMPONENT "Shared library")

install(FILES ${imebra_interface} DESTINATION include/imebra COMPONENT "Include files")

include(CPack)
