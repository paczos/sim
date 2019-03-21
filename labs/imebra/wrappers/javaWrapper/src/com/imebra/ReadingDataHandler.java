/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public class ReadingDataHandler {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected ReadingDataHandler(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(ReadingDataHandler obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        imebraJNI.delete_ReadingDataHandler(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public long getSize() {
    return imebraJNI.ReadingDataHandler_getSize(swigCPtr, this);
  }

  public tagVR_t getDataType() {
    return tagVR_t.swigToEnum(imebraJNI.ReadingDataHandler_getDataType(swigCPtr, this));
  }

  public int getSignedLong(long index) {
    return imebraJNI.ReadingDataHandler_getSignedLong(swigCPtr, this, index);
  }

  public long getUnsignedLong(long index) {
    return imebraJNI.ReadingDataHandler_getUnsignedLong(swigCPtr, this, index);
  }

  public double getDouble(long index) {
    return imebraJNI.ReadingDataHandler_getDouble(swigCPtr, this, index);
  }

  public String getString(long index) {
    return imebraJNI.ReadingDataHandler_getString(swigCPtr, this, index);
  }

  public SWIGTYPE_p_std__wstring getUnicodeString(long index) {
    return new SWIGTYPE_p_std__wstring(imebraJNI.ReadingDataHandler_getUnicodeString(swigCPtr, this, index), true);
  }

  public Date getDate(long index) {
    return new Date(imebraJNI.ReadingDataHandler_getDate(swigCPtr, this, index), true);
  }

  public Age getAge(long index) {
    return new Age(imebraJNI.ReadingDataHandler_getAge(swigCPtr, this, index), true);
  }

}
