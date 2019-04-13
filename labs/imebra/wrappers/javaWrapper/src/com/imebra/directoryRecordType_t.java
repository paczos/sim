/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public enum directoryRecordType_t {
  patient,
  study,
  series,
  image,
  overlay,
  modality_lut,
  voi_lut,
  curve,
  topic,
  visit,
  results,
  interpretation,
  study_component,
  stored_print,
  rt_dose,
  rt_structure_set,
  rt_plan,
  rt_treat_record,
  presentation,
  waveform,
  sr_document,
  key_object_doc,
  spectroscopy,
  raw_data,
  registration,
  fiducial,
  mrdr,
  endOfDirectoryRecordTypes;

  public final int swigValue() {
    return swigValue;
  }

  public static directoryRecordType_t swigToEnum(int swigValue) {
    directoryRecordType_t[] swigValues = directoryRecordType_t.class.getEnumConstants();
    if (swigValue < swigValues.length && swigValue >= 0 && swigValues[swigValue].swigValue == swigValue)
      return swigValues[swigValue];
    for (directoryRecordType_t swigEnum : swigValues)
      if (swigEnum.swigValue == swigValue)
        return swigEnum;
    throw new IllegalArgumentException("No enum " + directoryRecordType_t.class + " with value " + swigValue);
  }

  @SuppressWarnings("unused")
  private directoryRecordType_t() {
    this.swigValue = SwigNext.next++;
  }

  @SuppressWarnings("unused")
  private directoryRecordType_t(int swigValue) {
    this.swigValue = swigValue;
    SwigNext.next = swigValue+1;
  }

  @SuppressWarnings("unused")
  private directoryRecordType_t(directoryRecordType_t swigEnum) {
    this.swigValue = swigEnum.swigValue;
    SwigNext.next = this.swigValue+1;
  }

  private final int swigValue;

  private static class SwigNext {
    private static int next = 0;
  }
}
