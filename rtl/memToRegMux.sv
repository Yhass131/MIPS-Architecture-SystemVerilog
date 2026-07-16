`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
//
// Create Date: 07/08/2026 05:35:03 PM
// Design Name: MIPS
// Module Name: memToRegMux
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Write-back data selection MUX. Chooses what gets written to the
// destination register: the ALU result (R-type/I-type arithmetic and
// address calculations), memory read data (lw), or PC+4 (jal).
//
// Inputs:
//   MemToReg   - 2-bit  - writeback select: 00=ALU result, 01=mem data, 10=PC+4
//   ALUOut     - 32-bit - ALU result
//   ReadData   - 32-bit - data memory read data
//   PCAdder    - 32-bit - PC+4
// Outputs:
//   WriteData  - 32-bit - selected value written back to the register file
//
// Dependencies:
// None
//
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module memToRegMux(
    input logic [1:0] MemToReg,
    input logic [31:0] ALUOut,
    input logic [31:0] ReadData,
    input logic [31:0] PCAdder,
    output logic [31:0] WriteData
    );
    
    
    always_comb begin
        case (MemToReg)
              2'b00: WriteData = ALUOut;     //ALU result
              2'b01: WriteData = ReadData;   //Data Memory
              2'b10: WriteData = PCAdder;    //PC+4 for jal
              default: WriteData = '0;      //default
       endcase
    end                          
    
endmodule
