/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public class AssociationMessage {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected AssociationMessage(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(AssociationMessage obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        imebraJNI.delete_AssociationMessage(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public AssociationMessage(String abstractSyntax) {
    this(imebraJNI.new_AssociationMessage(abstractSyntax), true);
  }

  public String getAbstractSyntax() {
    return imebraJNI.AssociationMessage_getAbstractSyntax(swigCPtr, this);
  }

  public DataSet getCommand() {
    long cPtr = imebraJNI.AssociationMessage_getCommand(swigCPtr, this);
    return (cPtr == 0) ? null : new DataSet(cPtr, true);
  }

  public DataSet getPayload() {
    long cPtr = imebraJNI.AssociationMessage_getPayload(swigCPtr, this);
    return (cPtr == 0) ? null : new DataSet(cPtr, true);
  }

  public boolean hasPayload() {
    return imebraJNI.AssociationMessage_hasPayload(swigCPtr, this);
  }

  public void addDataSet(DataSet dataSet) {
    imebraJNI.AssociationMessage_addDataSet(swigCPtr, this, DataSet.getCPtr(dataSet), dataSet);
  }

}
