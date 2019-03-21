Definitions
===========

Introduction
------------

This chapter describes the auxiliary classes and definitions of the Imebra library.


The following classes are described in this chapter:

+-----------------------------------------------+---------------------------------------------+-------------------------------+
|C++ class                                      |Objective-C/Swift class                      |Description                    |
+===============================================+=============================================+===============================+
|:cpp:class:`imebra::tagId_t`                   |:cpp:class:`ImebraTagId_t`                   |Enumerates the known DICOM     |
|                                               |                                             |tags                           |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::ageUnit_t`                 |:cpp:class:`ImebraAgeUnit_t`                 |Enumerates the Age units       |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::tagVR_t`                   |:cpp:class:`ImebraTagVR_t`                   |Enumerates the DICOM VRs       |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::Age`                       |:cpp:class:`ImebraAge`                       |Age class                      |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::Date`                      |:cpp:class:`ImebraDate`                      |Date class                     |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::imageQuality_t`            |:cpp:class:`ImebraImageQuality_t`            |Enumerates the image quality   |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::bitDepth_t`                |:cpp:class:`ImebraBitDepth_t`                |Enumerates the image bit depths|
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::drawBitmapType_t`          |:cpp:class:`ImebraDrawBitmapType_t`          |Enumerates the bitmap types    |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::directoryRecordType_t`     |:cpp:class:`ImebraDirectoryRecordType_t`     |Enumerates the DICOMDIR record |
|                                               |                                             |types                          |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::fileParts_t`               |NSArray                                      |List of file path parts        |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::codecType_t`               |:cpp:class:`ImebraCodecType_t`               |Enumerates the codec types     |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::VOIDescription`            |:cpp:class:`ImebraVOIDescription`            |Hold the VOI description       |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::vois_t`                    |NSArray                                      |List of VOIs descriptions      |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::dimseCommandType_t`        |:cpp:class:`ImebraDimseCommandType_t`        |Enumerates the DIMSE commands  |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::dimseCommandPriority_t`    |:cpp:class:`ImebraDimseCommandPriority_t`    |Enumerates the DIMSE priorities|
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::dimseStatusCode_t`         |:cpp:class:`ImebraDimseStatusCode_t`         |Enumerates the DIMSE status    |
|                                               |                                             |codes                          |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::dimseStatus_t`             |:cpp:class:`ImebraDimseStatus_t`             |Enumerates the DIMSE statuses  |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::attributeIdentifierList_t` |NSArray                                      |List of attribute identifiers  |
+-----------------------------------------------+---------------------------------------------+-------------------------------+


Tag related definitions
-----------------------

tagId_t
.......

C++
,,,

.. doxygenenum:: imebra::tagId_t

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenenum:: ImebraTagId_t


ageUnit_t
.........

C++
,,,

.. doxygenenum:: imebra::ageUnit_t

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenenum:: ImebraAgeUnit_t


tagVR_t
.......

C++
,,,

.. doxygenenum:: imebra::tagVR_t

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenenum:: ImebraTagVR_t


Age
...

C++
,,,

.. doxygenstruct:: imebra::Age
   :members:

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenstruct:: ImebraAge
   :members:


Date
....

C++
,,,

.. doxygenstruct:: imebra::Date
   :members:

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenstruct:: ImebraDate
   :members:


Image related definitions
-------------------------

imageQuality_t
..............

C++
,,,

.. doxygenenum:: imebra::imageQuality_t

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenenum:: ImebraImageQuality_t


bitDepth_t
..........

C++
,,,

.. doxygenenum:: imebra::bitDepth_t

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenenum:: ImebraBitDepth_t


drawBitmapType_t
................

C++
,,,

.. doxygenenum:: imebra::drawBitmapType_t

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenenum:: ImebraDrawBitmapType_t



DICOMDIR related definitions
----------------------------

directoryRecordType_t
.....................

C++
,,,

.. doxygenenum:: imebra::directoryRecordType_t

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenenum:: ImebraDirectoryRecordType_t


fileParts_t
...........

C++
,,,

.. doxygentypedef:: imebra::fileParts_t


Codec Factory related definitions
---------------------------------

codecType_t
...........

C++
,,,

.. doxygenenum:: imebra::codecType_t

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenenum:: ImebraCodecType_t


VOI related definitions
-----------------------

VOIDescription
..............

C++
,,,

.. doxygenstruct:: imebra::VOIDescription
   :members:

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenstruct:: ImebraVOIDescription
   :members:


vois_t
......

C++
,,,

.. doxygentypedef:: imebra::vois_t



DIMSE related definitions
-------------------------

dimseCommandType_t
..................

C++
,,,

.. doxygenenum:: imebra::dimseCommandType_t

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenenum:: ImebraDimseCommandType_t


dimseCommandPriority_t
......................

C++
,,,

.. doxygenenum:: imebra::dimseCommandPriority_t

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenenum:: ImebraDimseCommandPriority_t


dimseStatusCode_t
.................

C++
,,,

.. doxygenenum:: imebra::dimseStatusCode_t

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenenum:: ImebraDimseStatusCode_t


dimseStatus_t
.............

C++
,,,

.. doxygenenum:: imebra::dimseStatus_t

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenenum:: ImebraDimseStatus_t


attributeIdentifierList_t
.........................

C++
,,,

.. doxygentypedef:: imebra::attributeIdentifierList_t


