/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public class CPartialResponse extends DimseResponse {
  private transient long swigCPtr;

  protected CPartialResponse(long cPtr, boolean cMemoryOwn) {
    super(imebraJNI.CPartialResponse_SWIGUpcast(cPtr), cMemoryOwn);
    swigCPtr = cPtr;
  }

  protected static long getCPtr(CPartialResponse obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        imebraJNI.delete_CPartialResponse(swigCPtr);
      }
      swigCPtr = 0;
    }
    super.delete();
  }

  public long getRemainingSubOperations() {
    return imebraJNI.CPartialResponse_getRemainingSubOperations(swigCPtr, this);
  }

  public long getCompletedSubOperations() {
    return imebraJNI.CPartialResponse_getCompletedSubOperations(swigCPtr, this);
  }

  public long getFailedSubOperations() {
    return imebraJNI.CPartialResponse_getFailedSubOperations(swigCPtr, this);
  }

  public long getWarningSubOperations() {
    return imebraJNI.CPartialResponse_getWarningSubOperations(swigCPtr, this);
  }

}
