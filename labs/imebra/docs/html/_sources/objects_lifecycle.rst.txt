Objects lifecycle and Object ownership
======================================

This chapter describes the lifecycle of the Imebra Objects and who is responsible for managing it.

Objects are handles
-------------------

The internal objects allocated by Imebra are not exposed directly to the client application: instead of the real object, a proxy one is presented to the
client application. This is true both for Imebra objects allocated by the library itself and for the ones allocated by the client application.

This means that for each class visible by the client application (e.g. :ref:`DataSet`) there is a counterpart class (e.g. DataSetImplementation)
which actually performs all the heavy lifting: :ref:`DataSet` (the exposed class) just holds a shared pointer to DataSetImplementation and forwards
all the function calls to it.

When an Imebra object is passed as parameter to a method, then a shared pointer referencing the hidden object is passed to the underlying method:
this means that the client application can freely delete the Imebra objects it sees while resting assured that the actual working object will
be deleted only when all the methods and classes using it have finished with it.

.. figure:: images/objectsLifecycle.jpg
   :target: _images/objectsLifecycle.jpg
   :figwidth: 100%
   :alt: Imebra public classes and implementation classes

   Example of Imebra public class and implementation class



Pointer to objects are owned by the client application
------------------------------------------------------

When an Imebra method returns a pointer to an object, then it is the responsibility of the client application to delete it.

Since the objects returned by Imebra are just handles for the real implementation objects, the client application can safely delete
the received object as soon as it has finished using it while resting assured that the underlying implementation object will be
deallocated only when all the classes and methods using it have finished using it.



.. figure:: images/sequence_objectsLifecycle.jpg
   :target: _images/sequence_objectsLifecycle.jpg
   :figwidth: 100%
   :alt: Example of object lifecycle

   The DataSetImplementation object stays alive until all the objects needing it dismiss it.

