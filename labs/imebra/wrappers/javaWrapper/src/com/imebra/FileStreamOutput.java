/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public class FileStreamOutput extends BaseStreamOutput {
  private transient long swigCPtr;

  protected FileStreamOutput(long cPtr, boolean cMemoryOwn) {
    super(imebraJNI.FileStreamOutput_SWIGUpcast(cPtr), cMemoryOwn);
    swigCPtr = cPtr;
  }

  protected static long getCPtr(FileStreamOutput obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        imebraJNI.delete_FileStreamOutput(swigCPtr);
      }
      swigCPtr = 0;
    }
    super.delete();
  }

  public FileStreamOutput(String name) {
    this(imebraJNI.new_FileStreamOutput(name), true);
  }

}
