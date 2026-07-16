`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
//
// Create Date: 07/08/2026 04:05:25 PM
// Design Name: MIPS
// Module Name: pcadder
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Computes PC+4, the sequential next-instruction address. Used both as
// the default next-PC value and as the base for the branch target
// address (branch_adder) and jump target address (JmpTargetAddr).
//
// Inputs:
//   CurrAddr   - 32-bit - current PC value
// Outputs:
//   NextAddr   - 32-bit - CurrAddr + 4
//
// Dependencies:
// None
//
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module pcadder(
    input logic [31:0] CurrAddr,
    output logic [31:0] NextAddr
    );
    
    assign NextAddr = CurrAddr + 4;
endmodule
