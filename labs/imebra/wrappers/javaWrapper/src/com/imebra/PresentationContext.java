/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public class PresentationContext {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected PresentationContext(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(PresentationContext obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        imebraJNI.delete_PresentationContext(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public PresentationContext(String abstractSyntax) {
    this(imebraJNI.new_PresentationContext__SWIG_0(abstractSyntax), true);
  }

  public PresentationContext(String abstractSyntax, boolean bSCURole, boolean bSCPRole) {
    this(imebraJNI.new_PresentationContext__SWIG_1(abstractSyntax, bSCURole, bSCPRole), true);
  }

  public void addTransferSyntax(String transferSyntax) {
    imebraJNI.PresentationContext_addTransferSyntax(swigCPtr, this, transferSyntax);
  }

}
