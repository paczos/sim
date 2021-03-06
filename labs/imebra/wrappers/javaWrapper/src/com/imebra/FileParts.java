/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public class FileParts {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected FileParts(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(FileParts obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        imebraJNI.delete_FileParts(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public FileParts() {
    this(imebraJNI.new_FileParts__SWIG_0(), true);
  }

  public FileParts(long n) {
    this(imebraJNI.new_FileParts__SWIG_1(n), true);
  }

  public long size() {
    return imebraJNI.FileParts_size(swigCPtr, this);
  }

  public long capacity() {
    return imebraJNI.FileParts_capacity(swigCPtr, this);
  }

  public void reserve(long n) {
    imebraJNI.FileParts_reserve(swigCPtr, this, n);
  }

  public boolean isEmpty() {
    return imebraJNI.FileParts_isEmpty(swigCPtr, this);
  }

  public void clear() {
    imebraJNI.FileParts_clear(swigCPtr, this);
  }

  public void add(String x) {
    imebraJNI.FileParts_add(swigCPtr, this, x);
  }

  public String get(int i) {
    return imebraJNI.FileParts_get(swigCPtr, this, i);
  }

  public void set(int i, String val) {
    imebraJNI.FileParts_set(swigCPtr, this, i, val);
  }

}
