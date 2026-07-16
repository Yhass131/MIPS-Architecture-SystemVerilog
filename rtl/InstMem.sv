`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
//
// Create Date: 07/08/2026 06:16:42 PM
// Design Name: MIPS
// Module Name: InstMem
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Word-addressable, read-only instruction memory for the single-cycle MIPS
// datapath. 64 words x 32 bits, loaded once at elaboration from an Intel
// hex file named by the PROGRAM parameter via $readmemh. Addressed by
// addr[6:2] (byte address, word-aligned; addr[1:0] is ignored).
//
// Inputs:
//   addr      - 32-bit - byte address (word-aligned; only [6:2] used)
// Outputs:
//   inst_out  - 32-bit - instruction word at addr
//
// Dependencies:
// None
//
// Additional Comments:
// PROGRAM's default value is a developer-machine-specific absolute path,
// used only as a fallback. TopLevel_tb overrides the loaded program per
// test by writing mem[] directly via a hierarchical reference
// (Top.instMem0.mem) and calling $readmemh itself, so the default is
// never relied on during regression testing.
//////////////////////////////////////////////////////////////////////////////////


module InstMem #(
    parameter string PROGRAM = "program/multiply.hex" //Replace with testing file
)(
    input  logic [31:0] addr,
    output logic [31:0] inst_out
);
    logic [31:0] mem [0:63];

    initial begin
        mem = '{default: '0};
        $readmemh(PROGRAM, mem);
    end

    assign inst_out = mem[addr[6:2]];
endmodule




