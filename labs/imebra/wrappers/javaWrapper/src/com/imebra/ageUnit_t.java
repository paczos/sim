/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public enum ageUnit_t {
  days(imebraJNI.ageUnit_t_days_get()),
  weeks(imebraJNI.ageUnit_t_weeks_get()),
  months(imebraJNI.ageUnit_t_months_get()),
  years(imebraJNI.ageUnit_t_years_get());

  public final int swigValue() {
    return swigValue;
  }

  public static ageUnit_t swigToEnum(int swigValue) {
    ageUnit_t[] swigValues = ageUnit_t.class.getEnumConstants();
    if (swigValue < swigValues.length && swigValue >= 0 && swigValues[swigValue].swigValue == swigValue)
      return swigValues[swigValue];
    for (ageUnit_t swigEnum : swigValues)
      if (swigEnum.swigValue == swigValue)
        return swigEnum;
    throw new IllegalArgumentException("No enum " + ageUnit_t.class + " with value " + swigValue);
  }

  @SuppressWarnings("unused")
  private ageUnit_t() {
    this.swigValue = SwigNext.next++;
  }

  @SuppressWarnings("unused")
  private ageUnit_t(int swigValue) {
    this.swigValue = swigValue;
    SwigNext.next = swigValue+1;
  }

  @SuppressWarnings("unused")
  private ageUnit_t(ageUnit_t swigEnum) {
    this.swigValue = swigEnum.swigValue;
    SwigNext.next = this.swigValue+1;
  }

  private final int swigValue;

  private static class SwigNext {
    private static int next = 0;
  }
}

