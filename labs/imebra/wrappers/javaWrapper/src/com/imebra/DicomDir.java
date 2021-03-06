/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public class DicomDir {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected DicomDir(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(DicomDir obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        imebraJNI.delete_DicomDir(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public DicomDir() {
    this(imebraJNI.new_DicomDir__SWIG_0(), true);
  }

  public DicomDir(DataSet fromDataSet) {
    this(imebraJNI.new_DicomDir__SWIG_1(DataSet.getCPtr(fromDataSet), fromDataSet), true);
  }

  public DicomDirEntry getNewEntry(directoryRecordType_t recordType) {
    long cPtr = imebraJNI.DicomDir_getNewEntry(swigCPtr, this, recordType.swigValue());
    return (cPtr == 0) ? null : new DicomDirEntry(cPtr, true);
  }

  public DicomDirEntry getFirstRootEntry() {
    long cPtr = imebraJNI.DicomDir_getFirstRootEntry(swigCPtr, this);
    return (cPtr == 0) ? null : new DicomDirEntry(cPtr, true);
  }

  public void setFirstRootEntry(DicomDirEntry firstEntryRecord) {
    imebraJNI.DicomDir_setFirstRootEntry(swigCPtr, this, DicomDirEntry.getCPtr(firstEntryRecord), firstEntryRecord);
  }

  public DataSet updateDataSet() {
    long cPtr = imebraJNI.DicomDir_updateDataSet(swigCPtr, this);
    return (cPtr == 0) ? null : new DataSet(cPtr, true);
  }

}
