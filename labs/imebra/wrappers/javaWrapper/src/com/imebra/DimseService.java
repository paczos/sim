/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.imebra;

public class DimseService {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected DimseService(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(DimseService obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        imebraJNI.delete_DimseService(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public DimseService(AssociationBase association) {
    this(imebraJNI.new_DimseService(AssociationBase.getCPtr(association), association), true);
  }

  public String getTransferSyntax(String abstractSyntax) {
    return imebraJNI.DimseService_getTransferSyntax(swigCPtr, this, abstractSyntax);
  }

  public int getNextCommandID() {
    return imebraJNI.DimseService_getNextCommandID(swigCPtr, this);
  }

  public DimseCommand getCommand() {
    return imebraJNI.DimseService_getCommand(swigCPtr, this);
  }

  public void sendCommandOrResponse(DimseCommandBase command) {
    imebraJNI.DimseService_sendCommandOrResponse(swigCPtr, this, DimseCommandBase.getCPtr(command), command);
  }

  public CStoreResponse getCStoreResponse(CStoreCommand command) {
    long cPtr = imebraJNI.DimseService_getCStoreResponse(swigCPtr, this, CStoreCommand.getCPtr(command), command);
    return (cPtr == 0) ? null : new CStoreResponse(cPtr, true);
  }

  public CGetResponse getCGetResponse(CGetCommand command) {
    long cPtr = imebraJNI.DimseService_getCGetResponse(swigCPtr, this, CGetCommand.getCPtr(command), command);
    return (cPtr == 0) ? null : new CGetResponse(cPtr, true);
  }

  public CFindResponse getCFindResponse(CFindCommand command) {
    long cPtr = imebraJNI.DimseService_getCFindResponse(swigCPtr, this, CFindCommand.getCPtr(command), command);
    return (cPtr == 0) ? null : new CFindResponse(cPtr, true);
  }

  public CMoveResponse getCMoveResponse(CMoveCommand command) {
    long cPtr = imebraJNI.DimseService_getCMoveResponse(swigCPtr, this, CMoveCommand.getCPtr(command), command);
    return (cPtr == 0) ? null : new CMoveResponse(cPtr, true);
  }

  public CEchoResponse getCEchoResponse(CEchoCommand command) {
    long cPtr = imebraJNI.DimseService_getCEchoResponse(swigCPtr, this, CEchoCommand.getCPtr(command), command);
    return (cPtr == 0) ? null : new CEchoResponse(cPtr, true);
  }

  public NEventReportResponse getNEventReportResponse(NEventReportCommand command) {
    long cPtr = imebraJNI.DimseService_getNEventReportResponse(swigCPtr, this, NEventReportCommand.getCPtr(command), command);
    return (cPtr == 0) ? null : new NEventReportResponse(cPtr, true);
  }

  public NGetResponse getNGetResponse(NGetCommand command) {
    long cPtr = imebraJNI.DimseService_getNGetResponse(swigCPtr, this, NGetCommand.getCPtr(command), command);
    return (cPtr == 0) ? null : new NGetResponse(cPtr, true);
  }

  public NSetResponse getNSetResponse(NSetCommand command) {
    long cPtr = imebraJNI.DimseService_getNSetResponse(swigCPtr, this, NSetCommand.getCPtr(command), command);
    return (cPtr == 0) ? null : new NSetResponse(cPtr, true);
  }

  public NActionResponse getNActionResponse(NActionCommand command) {
    long cPtr = imebraJNI.DimseService_getNActionResponse(swigCPtr, this, NActionCommand.getCPtr(command), command);
    return (cPtr == 0) ? null : new NActionResponse(cPtr, true);
  }

  public NCreateResponse getNCreateResponse(NCreateCommand command) {
    long cPtr = imebraJNI.DimseService_getNCreateResponse(swigCPtr, this, NCreateCommand.getCPtr(command), command);
    return (cPtr == 0) ? null : new NCreateResponse(cPtr, true);
  }

  public NDeleteResponse getNDeleteResponse(NDeleteCommand command) {
    long cPtr = imebraJNI.DimseService_getNDeleteResponse(swigCPtr, this, NDeleteCommand.getCPtr(command), command);
    return (cPtr == 0) ? null : new NDeleteResponse(cPtr, true);
  }

}
