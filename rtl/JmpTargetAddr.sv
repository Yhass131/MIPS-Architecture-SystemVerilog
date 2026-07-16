`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
//
// Create Date: 07/08/2026 04:57:40 PM
// Design Name: MIPS
// Module Name: JmpTargetAddr
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Computes the J-type jump target address for j and jal: the top 4 bits
// of PC+4 concatenated with the 26-bit instruction index field, shifted
// left 2. Does not decide whether this target is actually used - jmpLogic
// decides whether a jump is taken, and jmpSrcMux selects this value only
// when JmpSrc selects it over the jr target.
//
// Inputs:
//   PCAdder   - 32-bit - PC+4 (only bits [31:28] are used)
//   Inst      - 26-bit - instruction index field (Instr[25:0])
// Outputs:
//   JmpAddr   - 32-bit - {PCAdder[31:28], Inst, 2'b00}
//
// Dependencies:
// None
//
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module JmpTargetAddr(
    input logic [31:0] PCAdder,
    input logic [25:0] Inst,
    output logic [31:0] JmpAddr
    );
    
    assign JmpAddr = {PCAdder[31:28], Inst, 2'b00};
    
endmodule
