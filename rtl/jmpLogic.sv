`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
//
// Create Date: 07/08/2026 04:49:34 PM
// Design Name: MIPS
// Module Name: jmpLogic
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Jump-decision logic for j, jal, and jr. Decodes Opcode/Funct directly
// (independent of the control module) to decide whether the PC should
// redirect to a jump target this cycle, and if so, which target source
// to use. Does not compute the jump target address itself - JmpTargetAddr
// computes the j/jal target and jmpSrcMux selects between it and RF[rs]
// for jr.
//
// Inputs:
//   Opcode   - 6-bit - instruction opcode field (Instr[31:26])
//   Funct    - 6-bit - R-type function field (Instr[5:0]), checked for jr
// Outputs:
//   JmpOut   - 1-bit - high when the instruction is j, jal, or jr
//   JmpSrc   - 1-bit - high for jr (select RF[rs] as the jump target)
//
// Dependencies:
// None
//
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module jmpLogic(
    input logic [5:0] Opcode,
    input logic [5:0] Funct,
    output logic JmpOut,
    output logic JmpSrc
    );
    
    assign JmpOut = (Opcode == 6'b000010) ? 1'b1 :                              //j
                    (Opcode == 6'b000011) ? 1'b1 :                              //jal
                    ( (Opcode == 6'b000000) & (Funct == 6'b001000) ) ? 1'b1 :   //jr
                    1'b0;                                                       //no jump
   
   assign JmpSrc = ( (Opcode == 6'b000000) & (Funct == 6'b001000) ) ? 1'b1  : 1'b0; //Select RF[RS] only for jr
    
endmodule
