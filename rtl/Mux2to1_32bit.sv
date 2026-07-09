`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2026 08:19:15 PM
// Design Name: 
// Module Name: 2to1_32Mux
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


module mux2to1_32(
    input [31:0] A,
    input [31:0] B,
    input cntl,
    output [31:0] out
    );
    
    assign out = cntl ? A : B;
    
endmodule
