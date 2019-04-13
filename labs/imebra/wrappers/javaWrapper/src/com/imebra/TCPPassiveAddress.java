/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public class TCPPassiveAddress extends TCPAddress {
  private transient long swigCPtr;

  protected TCPPassiveAddress(long cPtr, boolean cMemoryOwn) {
    super(imebraJNI.TCPPassiveAddress_SWIGUpcast(cPtr), cMemoryOwn);
    swigCPtr = cPtr;
  }

  protected static long getCPtr(TCPPassiveAddress obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        imebraJNI.delete_TCPPassiveAddress(swigCPtr);
      }
      swigCPtr = 0;
    }
    super.delete();
  }

  public TCPPassiveAddress(String node, String service) {
    this(imebraJNI.new_TCPPassiveAddress(node, service), true);
  }

}