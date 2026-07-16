`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
//
// Create Date: 07/07/2026 07:08:13 PM
// Design Name: MIPS
// Module Name: RegFile
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// 32 x 32-bit general-purpose register file. Synchronous write on the
// clock edge when en and write_en are both asserted and write_reg is
// nonzero; reads are combinational and always return 0 for register 0,
// so $zero is enforced on both the write and read paths.
//
// Inputs:
//   clk          - 1-bit  - clock
//   en           - 1-bit  - step enable; gates writes
//   rst          - 1-bit  - synchronous reset, clears all 32 registers
//   write_en     - 1-bit  - register write enable
//   read_reg1    - 5-bit  - rs, first read port select
//   read_reg2    - 5-bit  - rt, second read port select
//   write_reg    - 5-bit  - destination register select
//   write_data   - 32-bit - value to write to write_reg
// Outputs:
//   read_data1   - 32-bit - value at read_reg1 (0 if read_reg1 == 0)
//   read_data2   - 32-bit - value at read_reg2 (0 if read_reg2 == 0)
//
// Dependencies:
// None
//
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module RegFile(
    input logic clk,
    input logic en,
    input logic rst,
    input logic write_en,
    input logic [4:0] read_reg1,
    input logic [4:0] read_reg2,
    input logic [4:0] write_reg,
    input logic [31:0] write_data,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2
    );
    
    logic [31:0] RAM [0:31];
    
    always_ff @(posedge clk) begin
        if(rst)
            RAM <= '{default: 0};
        else if ( en && write_en  && write_reg != 5'b00000 )
            RAM[write_reg] <= write_data;
    end
    
    assign read_data1 = (read_reg1 == '0) ? '0 : RAM[read_reg1];
    assign read_data2 = (read_reg2 == '0) ? '0 : RAM[read_reg2];
endmodule
