/* Automatically generated by meta-parse.py */

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

`include "Opcodes.defines"
import RVTypes::*;

typedef struct {
    Maybe#(RegType) rs1;
    Maybe#(RegType) rs2;
    Maybe#(RegType) rs3;
    Maybe#(RegType) dst;
    ImmType imm;
} InstType deriving (Bits, Eq, FShow);

function InstType toInstType(Instruction inst);
    Maybe#(RegType) i = tagged Valid Gpr;
    Maybe#(RegType) f = tagged Valid Fpu;
    Maybe#(RegType) n = tagged Invalid;
    InstType ret = (case (inst) matches
            `MRTS:          InstType{rs1: n, rs2: n, rs3: n, dst: n, imm: None};
            `LUI:           InstType{rs1: n, rs2: n, rs3: n, dst: i, imm: U   };
            `AUIPC:         InstType{rs1: n, rs2: n, rs3: n, dst: i, imm: U   };
            `JAL:           InstType{rs1: n, rs2: n, rs3: n, dst: i, imm: UJ  };
            `JALR:          InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `BEQ:           InstType{rs1: i, rs2: i, rs3: n, dst: n, imm: SB  };
            `BNE:           InstType{rs1: i, rs2: i, rs3: n, dst: n, imm: SB  };
            `BLT:           InstType{rs1: i, rs2: i, rs3: n, dst: n, imm: SB  };
            `BGE:           InstType{rs1: i, rs2: i, rs3: n, dst: n, imm: SB  };
            `BLTU:          InstType{rs1: i, rs2: i, rs3: n, dst: n, imm: SB  };
            `BGEU:          InstType{rs1: i, rs2: i, rs3: n, dst: n, imm: SB  };
            `LB:            InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `LH:            InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `LW:            InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `LBU:           InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `LHU:           InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `SB:            InstType{rs1: i, rs2: i, rs3: n, dst: n, imm: S   };
            `SH:            InstType{rs1: i, rs2: i, rs3: n, dst: n, imm: S   };
            `SW:            InstType{rs1: i, rs2: i, rs3: n, dst: n, imm: S   };
            `ADDI:          InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `SLTI:          InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `SLTIU:         InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `XORI:          InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `ORI:           InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `ANDI:          InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `ADD:           InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `SUB:           InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `SLL:           InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `SLT:           InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `SLTU:          InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `XOR:           InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `SRL:           InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `SRA:           InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `OR:            InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AND:           InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `FENCE:         InstType{rs1: n, rs2: n, rs3: n, dst: n, imm: None};
            `FENCE_I:       InstType{rs1: n, rs2: n, rs3: n, dst: n, imm: None};
            `LWU:           InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `LD:            InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `SD:            InstType{rs1: i, rs2: i, rs3: n, dst: n, imm: S   };
            `SLLI:          InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `SRLI:          InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `SRAI:          InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `ADDIW:         InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `SLLIW:         InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `SRLIW:         InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `SRAIW:         InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: I   };
            `ADDW:          InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `SUBW:          InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `SLLW:          InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `SRLW:          InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `SRAW:          InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `MUL:           InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `MULH:          InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `MULHSU:        InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `MULHU:         InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `DIV:           InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `DIVU:          InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `REM:           InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `REMU:          InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `MULW:          InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `DIVW:          InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `DIVUW:         InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `REMW:          InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `REMUW:         InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `LR_W:          InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: None};
            `SC_W:          InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOSWAP_W:     InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOADD_W:      InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOXOR_W:      InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOOR_W:       InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOAND_W:      InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOMIN_W:      InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOMAX_W:      InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOMINU_W:     InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOMAXU_W:     InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `LR_D:          InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: None};
            `SC_D:          InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOSWAP_D:     InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOADD_D:      InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOXOR_D:      InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOOR_D:       InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOAND_D:      InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOMIN_D:      InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOMAX_D:      InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOMINU_D:     InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `AMOMAXU_D:     InstType{rs1: i, rs2: i, rs3: n, dst: i, imm: None};
            `ECALL:         InstType{rs1: n, rs2: n, rs3: n, dst: n, imm: None};
            `EBREAK:        InstType{rs1: n, rs2: n, rs3: n, dst: n, imm: None};
            `URET:          InstType{rs1: n, rs2: n, rs3: n, dst: n, imm: None};
            `SRET:          InstType{rs1: n, rs2: n, rs3: n, dst: n, imm: None};
            `HRET:          InstType{rs1: n, rs2: n, rs3: n, dst: n, imm: None};
            `MRET:          InstType{rs1: n, rs2: n, rs3: n, dst: n, imm: None};
            `DRET:          InstType{rs1: n, rs2: n, rs3: n, dst: n, imm: None};
            `SFENCE_VM:     InstType{rs1: i, rs2: n, rs3: n, dst: n, imm: None};
            `WFI:           InstType{rs1: n, rs2: n, rs3: n, dst: n, imm: None};
            `CSRRW:         InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: None};
            `CSRRS:         InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: None};
            `CSRRC:         InstType{rs1: i, rs2: n, rs3: n, dst: i, imm: None};
            `CSRRWI:        InstType{rs1: n, rs2: n, rs3: n, dst: i, imm: Z   };
            `CSRRSI:        InstType{rs1: n, rs2: n, rs3: n, dst: i, imm: Z   };
            `CSRRCI:        InstType{rs1: n, rs2: n, rs3: n, dst: i, imm: Z   };
            `FLW:           InstType{rs1: i, rs2: n, rs3: n, dst: f, imm: I   };
            `FSW:           InstType{rs1: i, rs2: f, rs3: n, dst: n, imm: S   };
            `FMADD_S:       InstType{rs1: f, rs2: f, rs3: f, dst: f, imm: None};
            `FMSUB_S:       InstType{rs1: f, rs2: f, rs3: f, dst: f, imm: None};
            `FNMSUB_S:      InstType{rs1: f, rs2: f, rs3: f, dst: f, imm: None};
            `FNMADD_S:      InstType{rs1: f, rs2: f, rs3: f, dst: f, imm: None};
            `FADD_S:        InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FSUB_S:        InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FMUL_S:        InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FDIV_S:        InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FSGNJ_S:       InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FSGNJN_S:      InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FSGNJX_S:      InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FMIN_S:        InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FMAX_S:        InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FSQRT_S:       InstType{rs1: f, rs2: n, rs3: n, dst: f, imm: None};
            `FLE_S:         InstType{rs1: f, rs2: f, rs3: n, dst: i, imm: None};
            `FLT_S:         InstType{rs1: f, rs2: f, rs3: n, dst: i, imm: None};
            `FEQ_S:         InstType{rs1: f, rs2: f, rs3: n, dst: i, imm: None};
            `FCVT_W_S:      InstType{rs1: f, rs2: n, rs3: n, dst: i, imm: None};
            `FCVT_WU_S:     InstType{rs1: f, rs2: n, rs3: n, dst: i, imm: None};
            `FCVT_S_W:      InstType{rs1: i, rs2: n, rs3: n, dst: f, imm: None};
            `FCVT_S_WU:     InstType{rs1: i, rs2: n, rs3: n, dst: f, imm: None};
            `FMV_X_S:       InstType{rs1: f, rs2: n, rs3: n, dst: i, imm: None};
            `FCLASS_S:      InstType{rs1: f, rs2: n, rs3: n, dst: i, imm: None};
            `FMV_S_X:       InstType{rs1: i, rs2: n, rs3: n, dst: f, imm: None};
            `FCVT_L_S:      InstType{rs1: f, rs2: n, rs3: n, dst: i, imm: None};
            `FCVT_LU_S:     InstType{rs1: f, rs2: n, rs3: n, dst: i, imm: None};
            `FCVT_S_L:      InstType{rs1: i, rs2: n, rs3: n, dst: f, imm: None};
            `FCVT_S_LU:     InstType{rs1: i, rs2: n, rs3: n, dst: f, imm: None};
            `FLD:           InstType{rs1: i, rs2: n, rs3: n, dst: f, imm: I   };
            `FSD:           InstType{rs1: i, rs2: f, rs3: n, dst: n, imm: S   };
            `FMADD_D:       InstType{rs1: f, rs2: f, rs3: f, dst: f, imm: None};
            `FMSUB_D:       InstType{rs1: f, rs2: f, rs3: f, dst: f, imm: None};
            `FNMSUB_D:      InstType{rs1: f, rs2: f, rs3: f, dst: f, imm: None};
            `FNMADD_D:      InstType{rs1: f, rs2: f, rs3: f, dst: f, imm: None};
            `FADD_D:        InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FSUB_D:        InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FMUL_D:        InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FDIV_D:        InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FSGNJ_D:       InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FSGNJN_D:      InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FSGNJX_D:      InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FMIN_D:        InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FMAX_D:        InstType{rs1: f, rs2: f, rs3: n, dst: f, imm: None};
            `FCVT_S_D:      InstType{rs1: f, rs2: n, rs3: n, dst: f, imm: None};
            `FCVT_D_S:      InstType{rs1: f, rs2: n, rs3: n, dst: f, imm: None};
            `FSQRT_D:       InstType{rs1: f, rs2: n, rs3: n, dst: f, imm: None};
            `FLE_D:         InstType{rs1: f, rs2: f, rs3: n, dst: i, imm: None};
            `FLT_D:         InstType{rs1: f, rs2: f, rs3: n, dst: i, imm: None};
            `FEQ_D:         InstType{rs1: f, rs2: f, rs3: n, dst: i, imm: None};
            `FCVT_W_D:      InstType{rs1: f, rs2: n, rs3: n, dst: i, imm: None};
            `FCVT_WU_D:     InstType{rs1: f, rs2: n, rs3: n, dst: i, imm: None};
            `FCVT_D_W:      InstType{rs1: i, rs2: n, rs3: n, dst: f, imm: None};
            `FCVT_D_WU:     InstType{rs1: i, rs2: n, rs3: n, dst: f, imm: None};
            `FCLASS_D:      InstType{rs1: f, rs2: n, rs3: n, dst: i, imm: None};
            `FCVT_L_D:      InstType{rs1: f, rs2: n, rs3: n, dst: i, imm: None};
            `FCVT_LU_D:     InstType{rs1: f, rs2: n, rs3: n, dst: i, imm: None};
            `FMV_X_D:       InstType{rs1: f, rs2: n, rs3: n, dst: i, imm: None};
            `FCVT_D_L:      InstType{rs1: i, rs2: n, rs3: n, dst: f, imm: None};
            `FCVT_D_LU:     InstType{rs1: i, rs2: n, rs3: n, dst: f, imm: None};
            `FMV_D_X:       InstType{rs1: i, rs2: n, rs3: n, dst: f, imm: None};
            default:        ?;
        endcase);
    if ((ret.dst == tagged Valid Gpr) && (getInstFields(inst).rd == 0)) begin
        ret.dst = tagged Invalid;
    end
    return ret;
endfunction