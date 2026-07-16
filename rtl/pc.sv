`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
//
// Create Date: 07/08/2026 03:55:26 PM
// Design Name: MIPS
// Module Name: pc
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Program counter register for the single-cycle MIPS datapath. Holds the
// current instruction address and advances to NextAddr on each enabled
// clock edge. Does not compute NextAddr itself - pcadder, the branch/jump
// muxes, and JmpTargetAddr/jmpSrcMux upstream in TopLevel decide what
// value it latches.
//
// Inputs:
//   EN         - 1-bit  - step enable (single-cycle advance)
//   RST        - 1-bit  - synchronous reset to address 0
//   CLK        - 1-bit  - clock
//   NextAddr   - 32-bit - next PC value to latch on the next enabled edge
// Outputs:
//   CurrAddr   - 32-bit - current PC value
//
// Dependencies:
// None
//
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module pc(
    input logic EN,
    input logic RST,
    input logic CLK,
    input logic [31:0] NextAddr,
    output logic [31:0] CurrAddr
    );
    
    always_ff @(posedge CLK) begin
        if(RST) 
            CurrAddr <= '0;   
        else if(EN)
            CurrAddr <= NextAddr;
    end
    
endmodule
