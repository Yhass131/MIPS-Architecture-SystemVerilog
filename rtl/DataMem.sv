`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
//
// Create Date: 07/08/2026 05:56:20 PM
// Design Name: MIPS
// Module Name: DataMem
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Word-addressable data memory for the single-cycle MIPS datapath (lw/sw).
// 64 words x 32 bits, addressed by Addr[6:2] (byte address, word-aligned;
// Addr[1:0] is ignored). Preloaded at elaboration with four nonzero words
// for simulation convenience; a write is only committed on a clock edge
// when both EN and MemWrite are asserted, matching the core's single-step
// enable.
//
// Inputs:
//   CLK        - 1-bit  - core clock
//   EN         - 1-bit  - datapath step enable; gates writes
//   Addr       - 32-bit - byte address (word-aligned; only [6:2] used)
//   WriteData  - 32-bit - data to store on sw
//   MemWrite   - 1-bit  - write enable (sw)
//   MemRead    - 1-bit  - read enable (lw)
// Outputs:
//   ReadData   - 32-bit - memory word at Addr when MemRead is asserted, else 0
//
// Dependencies:
// None
//
// Additional Comments:
// ReadData is forced to 0 whenever MemRead is deasserted rather than
// holding the last value, since MemtoReg only selects this path when a
// read was actually requested. The four preloaded words (2, 3, 5, 5) are
// simulation defaults - TopLevel_tb overwrites mem[] directly via a
// hierarchical reference before each test program runs.
//////////////////////////////////////////////////////////////////////////////////


module DataMem(
    input logic CLK,
    input logic EN,
    input logic [31:0] Addr,
    input logic [31:0] WriteData,
    input logic MemWrite,
    input logic MemRead,
    output logic [31:0] ReadData
    );
    
    logic [31:0] mem [0:63] = '{
    0: 32'h00000002, // 0x00  
    1: 32'h00000003, // 0x04  
    2: 32'h00000005, // 0x08  
    3: 32'h00000005, // 0x0C     
    default: 32'h00000000 };
    
    always_ff @(posedge CLK) begin
        if(EN & MemWrite)
            mem[Addr[6:2]] <= WriteData;
    end
    
    assign ReadData = MemRead ? mem[Addr[6:2]] : 32'h00000000;
endmodule
