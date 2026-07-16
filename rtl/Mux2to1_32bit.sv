`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
//
// Create Date: 07/08/2026 08:19:15 PM
// Design Name: MIPS
// Module Name: mux2to1_32
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Generic 2-input, 1-output 32-bit MUX used at two points in the PC
// update path to select the next PC value (branch-vs-sequential, then
// jump-vs-that result). Purely combinational and carries no knowledge of
// why either input was chosen - that decision is made by the caller
// (branch_logic's BranchOut or jmpLogic's JmpOut).
//
// Inputs:
//   A      - 32-bit - selected output when cntl is high
//   B      - 32-bit - selected output when cntl is low
//   cntl   - 1-bit  - select
// Outputs:
//   out    - 32-bit - selected value
//
// Dependencies:
// None
//
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module mux2to1_32(
    input logic [31:0] A,
    input logic [31:0] B,
    input logic cntl,
    output logic [31:0] out
    );
    
    assign out = cntl ? A : B;
    
endmodule
