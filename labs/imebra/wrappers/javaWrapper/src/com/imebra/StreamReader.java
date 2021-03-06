/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public class StreamReader {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected StreamReader(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(StreamReader obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        imebraJNI.delete_StreamReader(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public StreamReader(BaseStreamInput stream) {
    this(imebraJNI.new_StreamReader__SWIG_0(BaseStreamInput.getCPtr(stream), stream), true);
  }

  public StreamReader(BaseStreamInput stream, long virtualStart, long virtualLength) {
    this(imebraJNI.new_StreamReader__SWIG_1(BaseStreamInput.getCPtr(stream), stream, virtualStart, virtualLength), true);
  }

  public StreamReader getVirtualStream(long virtualStreamLength) {
    long cPtr = imebraJNI.StreamReader_getVirtualStream(swigCPtr, this, virtualStreamLength);
    return (cPtr == 0) ? null : new StreamReader(cPtr, true);
  }

  public void terminate() {
    imebraJNI.StreamReader_terminate(swigCPtr, this);
  }

}
