
// Copyright (c) 2016 Massachusetts Institute of Technology

// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use, copy,
// modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

`include "ProcConfig.bsv"

// ProcConnectal.bsv
// This is a wrapper to translate the generic Proc interface to an interface
// that is accepted by connectal.

// This assumes a Proc.bsv file that contains the mkProc definition
import Abstraction::*;
import BuildVector::*;
import ClientServer::*;
import Clocks::*;
import Connectable::*;
import GetPut::*;
import Proc::*;
import Vector::*;
import VerificationPacket::*;
import MemTypes::*;
import RVTypes::*;
import SharedMemoryBridge::*;
import UncachedBridge::*;
import PerfMonitorConnectal::*;

// ProcControlControl
interface ProcControlRequest;
    method Action reset;
    method Action start(Bit#(64) startPc, Bit#(64) verificationPacketsToIgnore, Bool sendSynchronizationPackets);
    method Action stop;
    method Action configure(Bit#(32) sharedMemRefPointer, Bit#(32) romRefPointer, Bit#(64) romBaseAddr, Bit#(64) externalMMIOBaseAddr);
endinterface
interface ProcControlIndication;
    method Action resetDone;
endinterface
// HostInterface
interface HostInterfaceRequest;
    method Action fromHost(Bit#(64) v);
endinterface
interface HostInterfaceIndication;
    method Action toHost(Bit#(64) v);
endinterface
// Verification
interface VerificationIndication;
    method Action getVerificationPacket(VerificationPacket packet);
endinterface
// PerfMonitor interfaces defined in PerfMonitor package
// ExternalMMIO
interface ExternalMMIOResponse;
    method Action response(Bool write, Bit#(64) data);
    method Action triggerExternalInterrupt;
endinterface
interface ExternalMMIORequest;
    method Action request(Bool write, Bit#(4) length, Bit#(64) addr, Bit#(64) data);
endinterface

// This is the interface of all the requests, the indications are passed in as
// parameters to the mkProcConnectal module.
interface ProcConnectal;
    interface ProcControlRequest procControlRequest;
    interface HostInterfaceRequest hostInterfaceRequest;
    interface PerfMonitorRequest perfMonitorRequest;
    interface ExternalMMIOResponse externalMMIOResponse;
    interface Vector#(1, MemReadClient#(64)) dmaReadClient;
    interface Vector#(1, MemWriteClient#(64)) dmaWriteClient;
    interface Vector#(1, MemReadClient#(64)) romReadClient;
endinterface

module [Module] mkProcConnectal#(ProcControlIndication procControlIndication,
                                 HostInterfaceIndication hostInterfaceIndication,
                                 VerificationIndication verificationIndication,
                                 PerfMonitorIndication perfMonitorIndication,
                                 ExternalMMIORequest externalMMIORequest)
                                (ProcConnectal);
    let clock <- exposeCurrentClock;
    let reset <- exposeCurrentReset;
    let procReset <- mkReset(10, True, clock);
    Reg#(Bool) resetSent <- mkReg(False);

    Proc#(MainMemoryWidth) proc <- mkProc(reset_by procReset.new_rst);

    SharedMemoryBridge#(MainMemoryWidth) sharedMemoryBridge <- mkSharedMemoryBridge;
    let memToSharedMem <- mkConnection(proc.mainMemory, sharedMemoryBridge.to_proc);

    UncachedBridge uncachedBridge <- mkUncachedBridge;
    let memToUncachedMem <- mkConnection(proc.uncachedMemory, uncachedBridge.toProc);

    // rules for connecting indications
    rule finishReset(resetSent && (sharedMemoryBridge.numberFlyingOperations == 0));
        resetSent <= False;
        procControlIndication.resetDone;
    endrule
    rule connectHostInterfaceIndication;
        let msg <- proc.toHost;
        hostInterfaceIndication.toHost(msg);
    endrule
    rule connectVerificationIndication;
        let msg <- proc.getVerificationPacket;
        verificationIndication.getVerificationPacket(msg);
    endrule
    rule connectExternalMMIORequest;
        let msg <- uncachedBridge.externalMMIO.request.get;
        Bit#(4) length = (case (msg.size)
                B: 1;
                H: 2;
                W: 4;
                D: 8;
            endcase);
        externalMMIORequest.request(msg.write, length, msg.addr, msg.data);
    endrule

    interface ProcControlRequest procControlRequest;
        method Action reset() if (!resetSent);
            // resets the processor
            procReset.assertReset();
            // flushes the pending memory requests
            sharedMemoryBridge.flushRespReqMem;
            resetSent <= True;
        endmethod
        method Action start(Bit#(64) startPc, Bit#(64) verificationPacketsToIgnore, Bool sendSynchronizationPackets);
            proc.start(startPc, verificationPacketsToIgnore, sendSynchronizationPackets);
        endmethod
        method Action stop();
            proc.stop;
        endmethod
        method Action configure(Bit#(32) sharedMemRefPointer, Bit#(32) romRefPointer, Bit#(64) romBaseAddr, Bit#(64) externalMMIOBaseAddr);
            // set miobase
            proc.configure(romBaseAddr);
            // configure shared memory
            sharedMemoryBridge.initSharedMem(sharedMemRefPointer, romBaseAddr);
            // configure ROM
            uncachedBridge.initUncachedMem(romRefPointer, romBaseAddr, externalMMIOBaseAddr);
        endmethod
    endinterface
    interface HostInterfaceRequest hostInterfaceRequest;
        method Action fromHost(Bit#(64) v);
            proc.fromHost(v);
        endmethod
    endinterface
    interface PerfMonitorRequest perfMonitorRequest;
        method Action reset;
            noAction;
        endmethod
        method Action setEnable(Bool en);
            noAction;
        endmethod
        method Action req(Bit#(32) index);
            perfMonitorIndication.resp(0);
        endmethod
    endinterface
    interface ExternalMMIOResponse externalMMIOResponse;
        method Action response(Bool write, Bit#(64) data);
            uncachedBridge.externalMMIO.response.put( UncachedMemResp{write: write, data: data} );
        endmethod
        method Action triggerExternalInterrupt;
            proc.triggerExternalInterrupt;
        endmethod
    endinterface

    interface MemReadClient dmaReadClient = vec(sharedMemoryBridge.to_host_read);
    interface MemWriteClient dmaWriteClient = vec(sharedMemoryBridge.to_host_write);
    interface MemReadClient romReadClient = vec(uncachedBridge.rom);
endmodule