`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
// 
// Create Date: 07/08/2026 08:19:15 PM
// Design Name: MIPS
// Module Name: branch_adder
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Computes the branch target address: PC+4 plus the sign-extended,
// left-shifted-by-2 branch offset. A is expected to be PC+4,
// B is expected to be the sign-extended immediate already
// shifted left 2 (SignExtImm << 2), computed at the instantiation site
// in TopLevel rather than inside this module.
//
// Inputs:
//   A, B       - 32-bit operands
// Outputs:
//   Sum        - 32-bit Sum
//
// Dependencies: 
// None
//
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module branch_adder(
    input logic [31:0] A,
    input logic [31:0] B,
    output logic [31:0] Sum
    );
    
    assign Sum = A + B;
    
endmodule
