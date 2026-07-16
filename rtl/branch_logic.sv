`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
// 
// Create Date: 07/08/2026 08:19:15 PM
// Design Name: MIPS
// Module Name: branch_logic
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Branch-decision logic for beq and bne. Based on the Branch select signal
// from the control unit, outputs Zero directly (beq: branch when operands
// are equal) or ~Zero (bne: branch when operands are not equal). Zero is
// computed upstream by the ALU, which has already performed rs - rt for
// any instruction reaching this module.
//
// Inputs:
//   Branch                     - Selection on what, if at all, to branch
//   Zero                       - ALU zero flag from rs - rt; high means
//                                 the compared operands are equal
// Outputs:
//   BranchOut                  - Signal to branch or not
//
// Dependencies: 
// None
//
// Additional Comments:
// The default case is important, without it, any Branch value other
// than 2'b01/2'b10 leaves BranchOut undriven in simulation (X), which
// propagates into the PC-select mux and corrupts every subsequent
// instruction fetch. Confirmed via regression testing - see README
// "Bugs found through testing." 
//////////////////////////////////////////////////////////////////////////////////


module branch_logic(
    input logic [1:0] Branch,
    input logic Zero,
    output logic BranchOut
    );
    
    always_comb begin
    
        case(Branch)
            2'b01: BranchOut = Zero;    //beq
            2'b10: BranchOut = ~Zero;   //bne
            default: BranchOut = '0;    //default, not a branch command
        endcase
    
    end
    
endmodule
