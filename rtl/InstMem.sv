`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2026 06:16:42 PM
// Design Name: 
// Module Name: InstMem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InstMem #(
    parameter string PROGRAM = "programs/Multiply.hex" //Replace with testing file
)(
    input  logic [31:0] addr,
    output logic [31:0] inst_out
);
    logic [31:0] mem [0:63];

    initial begin
        mem = '{default: '0};
        $readmemh(PROGRAM, mem);
    end

    assign inst_out = mem[addr[7:2]];
endmodule




