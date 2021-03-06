/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public class Tag {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected Tag(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(Tag obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        imebraJNI.delete_Tag(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public long getBuffersCount() {
    return imebraJNI.Tag_getBuffersCount(swigCPtr, this);
  }

  public boolean bufferExists(long bufferId) {
    return imebraJNI.Tag_bufferExists(swigCPtr, this, bufferId);
  }

  public long getBufferSize(long bufferId) {
    return imebraJNI.Tag_getBufferSize(swigCPtr, this, bufferId);
  }

  public ReadingDataHandler getReadingDataHandler(long bufferId) {
    long cPtr = imebraJNI.Tag_getReadingDataHandler(swigCPtr, this, bufferId);
    return (cPtr == 0) ? null : new ReadingDataHandler(cPtr, true);
  }

  public WritingDataHandler getWritingDataHandler(long bufferId) {
    long cPtr = imebraJNI.Tag_getWritingDataHandler(swigCPtr, this, bufferId);
    return (cPtr == 0) ? null : new WritingDataHandler(cPtr, true);
  }

  public ReadingDataHandlerNumeric getReadingDataHandlerNumeric(long bufferId) {
    long cPtr = imebraJNI.Tag_getReadingDataHandlerNumeric(swigCPtr, this, bufferId);
    return (cPtr == 0) ? null : new ReadingDataHandlerNumeric(cPtr, true);
  }

  public ReadingDataHandlerNumeric getReadingDataHandlerRaw(long bufferId) {
    long cPtr = imebraJNI.Tag_getReadingDataHandlerRaw(swigCPtr, this, bufferId);
    return (cPtr == 0) ? null : new ReadingDataHandlerNumeric(cPtr, true);
  }

  public WritingDataHandlerNumeric getWritingDataHandlerNumeric(long bufferId) {
    long cPtr = imebraJNI.Tag_getWritingDataHandlerNumeric(swigCPtr, this, bufferId);
    return (cPtr == 0) ? null : new WritingDataHandlerNumeric(cPtr, true);
  }

  public WritingDataHandlerNumeric getWritingDataHandlerRaw(long bufferId) {
    long cPtr = imebraJNI.Tag_getWritingDataHandlerRaw(swigCPtr, this, bufferId);
    return (cPtr == 0) ? null : new WritingDataHandlerNumeric(cPtr, true);
  }

  public StreamReader getStreamReader(long bufferId) {
    long cPtr = imebraJNI.Tag_getStreamReader(swigCPtr, this, bufferId);
    return (cPtr == 0) ? null : new StreamReader(cPtr, true);
  }

  public StreamWriter getStreamWriter(long bufferId) {
    long cPtr = imebraJNI.Tag_getStreamWriter(swigCPtr, this, bufferId);
    return (cPtr == 0) ? null : new StreamWriter(cPtr, true);
  }

  public DataSet getSequenceItem(long dataSetId) {
    long cPtr = imebraJNI.Tag_getSequenceItem(swigCPtr, this, dataSetId);
    return (cPtr == 0) ? null : new DataSet(cPtr, true);
  }

  public boolean sequenceItemExists(long dataSetId) {
    return imebraJNI.Tag_sequenceItemExists(swigCPtr, this, dataSetId);
  }

  public void setSequenceItem(long dataSetId, DataSet dataSet) {
    imebraJNI.Tag_setSequenceItem(swigCPtr, this, dataSetId, DataSet.getCPtr(dataSet), dataSet);
  }

  public void appendSequenceItem(DataSet dataSet) {
    imebraJNI.Tag_appendSequenceItem(swigCPtr, this, DataSet.getCPtr(dataSet), dataSet);
  }

  public tagVR_t getDataType() {
    return tagVR_t.swigToEnum(imebraJNI.Tag_getDataType(swigCPtr, this));
  }

}
