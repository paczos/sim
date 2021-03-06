/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public class MemoryPool {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected MemoryPool(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(MemoryPool obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        imebraJNI.delete_MemoryPool(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public static void flush() {
    imebraJNI.MemoryPool_flush();
  }

  public static long getUnusedMemorySize() {
    return imebraJNI.MemoryPool_getUnusedMemorySize();
  }

  public static void setMemoryPoolSize(long minMemoryBlockSize, long maxMemoryPoolSize) {
    imebraJNI.MemoryPool_setMemoryPoolSize(minMemoryBlockSize, maxMemoryPoolSize);
  }

  public MemoryPool() {
    this(imebraJNI.new_MemoryPool(), true);
  }

}
