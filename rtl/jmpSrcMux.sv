`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
//
// Create Date: 07/08/2026 04:46:26 PM
// Design Name: MIPS
// Module Name: jmpSrcMux
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// A 2-input, 1-output MUX that selects the jump target address routed to
// the PC. Chooses RF[rs] for jr, or the precomputed J-type target
// (JumpTargetAddr) for j/jal. Does not decide whether a jump is taken at
// all - that decision belongs to jmpLogic.
//
// Inputs:
//   JmpSrc           - 1-bit  - select: 1=RFRS (jr), 0=JumpTargetAddr (j/jal)
//   JumpTargetAddr   - 32-bit - precomputed j/jal target address
//   RFRS             - 32-bit - RF[rs] value, used as the jr target
// Outputs:
//   JumpAddr         - 32-bit - selected jump target address
//
// Dependencies:
// None
//
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module jmpSrcMux(
    input logic JmpSrc,
    input logic [31:0] JumpTargetAddr,
    input logic [31:0] RFRS,
    output logic [31:0] JumpAddr
    );
    
    assign JumpAddr = JmpSrc ? RFRS : JumpTargetAddr;
    
endmodule
