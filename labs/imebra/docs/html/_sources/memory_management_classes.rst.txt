Memory management classes
=========================

Introduction
------------

This chapter describes the classes and methods responsible for allocating and accessing the memory used by the Imebra classes.

The following classes are described in this chapter:

+-----------------------------------------------+---------------------------------------------+-------------------------------+
|C++ class                                      |Objective-C/Swift class                      |Description                    |
+===============================================+=============================================+===============================+
|:cpp:class:`imebra::ReadMemory`                |:cpp:class:`ImebraReadMemory`                |Allows to read the memory      |
|                                               |                                             |content                        |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::ReadWriteMemory`           |:cpp:class:`ImebraReadWriteMemory`           |Allows to read and write the   |
|                                               |                                             |memory content                 |
+-----------------------------------------------+---------------------------------------------+-------------------------------+
|:cpp:class:`imebra::MemoryPool`                |:cpp:class:`ImebraMemoryPool`                |Allocatess or reuse a memory   |
|                                               |                                             |block                          |
+-----------------------------------------------+---------------------------------------------+-------------------------------+

The inner working classes of the Imebra library use the :ref:`MemoryPool` class to allocate blocks of memory.

When a memory block allocated by :ref:`MemoryPool` is released then it is not deleted immediately but instead it is kept for
a while so it can be reused by classes than need a similar amount of memory.

.. figure:: images/memory.jpg
   :target: _images/memory.jpg
   :figwidth: 100%
   :alt: Memory related classes

   Class diagram of the memory classes


Memory access
-------------

ReadMemory
..........

C++
,,,

.. doxygenclass:: imebra::ReadMemory
   :members:

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenclass:: ImebraReadMemory
   :members:


ReadWriteMemory
...............

C++
,,,

.. doxygenclass:: imebra::ReadWriteMemory
   :members:

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenclass:: ImebraReadWriteMemory
   :members:


Memory allocation
-----------------

.. _MemoryPool:

MemoryPool
..........

C++
,,,

.. doxygenclass:: imebra::MemoryPool
   :members:

Objective-C/Swift
,,,,,,,,,,,,,,,,,

.. doxygenclass:: ImebraMemoryPool
   :members:



