`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
// 
// Create Date: 07/08/2026 08:19:15 PM
// Design Name: MIPS
// Module Name: ALU_bMux
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// A 2 input, 1 output MUX specifically for ALU's B operand
//
// Inputs:
//   ReadData2, sigExtImm       - 32-bit options for Mux
//   ALUSrc                     - 1-bit Select  
// Outputs:
//   B                          - 32-bit Mux Output
//
// Dependencies: 
// None
//
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_bMux(
    input logic ALUSrc,
    input logic [31:0] ReadData2,
    input logic [31:0] sigExtImm,
    output logic [31:0] B
    );
    
    assign B = ALUSrc ? sigExtImm : ReadData2;
    
endmodule
