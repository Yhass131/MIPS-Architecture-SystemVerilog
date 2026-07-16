`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
//
// Create Date: 07/08/2026 04:07:30 PM
// Design Name: MIPS
// Module Name: RegDest
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Selects the destination register field written back by the register
// file. Chooses Rt (I-type), Rd (R-type), or $ra/register 31 (jal); any
// other RegDst encoding falls back to register 0, which the register
// file's write path already ignores.
//
// Inputs:
//   RegDst   - 2-bit - select: 00=Rt, 01=Rd, 10=$ra(31)
//   Rt       - 5-bit - Instr[20:16]
//   Rd       - 5-bit - Instr[15:11]
// Outputs:
//   WReg     - 5-bit - selected destination register number
//
// Dependencies:
// None
//
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module RegDest(
    input logic [1:0] RegDst,
    input logic [4:0] Rt,
    input logic [4:0] Rd,
    output logic [4:0] WReg
    );
    
    assign WReg =   (RegDst == 2'b00) ? Rt :        //I-type
                    (RegDst == 2'b01) ? Rd :        //R-type
                    (RegDst == 2'b10) ? 5'b11111 :  //for jal
                                        5'b00000;   //$zero, no write, safe default 
    
endmodule
