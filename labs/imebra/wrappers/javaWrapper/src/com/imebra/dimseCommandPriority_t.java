/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public enum dimseCommandPriority_t {
  low(imebraJNI.dimseCommandPriority_t_low_get()),
  medium(imebraJNI.dimseCommandPriority_t_medium_get()),
  high(imebraJNI.dimseCommandPriority_t_high_get());

  public final int swigValue() {
    return swigValue;
  }

  public static dimseCommandPriority_t swigToEnum(int swigValue) {
    dimseCommandPriority_t[] swigValues = dimseCommandPriority_t.class.getEnumConstants();
    if (swigValue < swigValues.length && swigValue >= 0 && swigValues[swigValue].swigValue == swigValue)
      return swigValues[swigValue];
    for (dimseCommandPriority_t swigEnum : swigValues)
      if (swigEnum.swigValue == swigValue)
        return swigEnum;
    throw new IllegalArgumentException("No enum " + dimseCommandPriority_t.class + " with value " + swigValue);
  }

  @SuppressWarnings("unused")
  private dimseCommandPriority_t() {
    this.swigValue = SwigNext.next++;
  }

  @SuppressWarnings("unused")
  private dimseCommandPriority_t(int swigValue) {
    this.swigValue = swigValue;
    SwigNext.next = swigValue+1;
  }

  @SuppressWarnings("unused")
  private dimseCommandPriority_t(dimseCommandPriority_t swigEnum) {
    this.swigValue = swigEnum.swigValue;
    SwigNext.next = this.swigValue+1;
  }

  private final int swigValue;

  private static class SwigNext {
    private static int next = 0;
  }
}

