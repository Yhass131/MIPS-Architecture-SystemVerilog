`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
//
// Create Date: 07/08/2026 04:15:11 PM
// Design Name: MIPS
// Module Name: sign_ext
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Sign-extends the 16-bit immediate/offset field to 32 bits by replicating
// bit 15. Used unconditionally for every I-type instruction that needs an
// immediate, including andi/ori.
//
// Inputs:
//   Imm          - 16-bit - immediate/offset field (Instr[15:0])
// Outputs:
//   SignExtImm   - 32-bit - sign-extended immediate
//
// Dependencies:
// None
//
// Additional Comments:
// andi/ori route through this same sign extension rather than zero
// extension, which deviates from the MIPS spec for those two
// instructions - see control.sv's header for the same note.
//////////////////////////////////////////////////////////////////////////////////


module sign_ext(
    input logic [15:0] Imm,
    output logic [31:0] SignExtImm
    );
    
    assign SignExtImm = { {16{Imm[15]}} , Imm };
    
endmodule
