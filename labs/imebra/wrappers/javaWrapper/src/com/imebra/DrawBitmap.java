/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public class DrawBitmap {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected DrawBitmap(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(DrawBitmap obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        imebraJNI.delete_DrawBitmap(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public DrawBitmap() {
    this(imebraJNI.new_DrawBitmap__SWIG_0(), true);
  }

  public DrawBitmap(Transform transformsChain) {
    this(imebraJNI.new_DrawBitmap__SWIG_1(Transform.getCPtr(transformsChain), transformsChain), true);
  }

  public long getBitmap(Image image, drawBitmapType_t drawBitmapType, long rowAlignBytes, byte[] destination) {
    return imebraJNI.DrawBitmap_getBitmap__SWIG_0(swigCPtr, this, Image.getCPtr(image), image, drawBitmapType.swigValue(), rowAlignBytes, destination);
  }

  public ReadWriteMemory getBitmap(Image image, drawBitmapType_t drawBitmapType, long rowAlignBytes) {
    long cPtr = imebraJNI.DrawBitmap_getBitmap__SWIG_1(swigCPtr, this, Image.getCPtr(image), image, drawBitmapType.swigValue(), rowAlignBytes);
    return (cPtr == 0) ? null : new ReadWriteMemory(cPtr, true);
  }

}
