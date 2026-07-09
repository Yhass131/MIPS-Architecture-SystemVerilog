`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2026 05:42:34 PM
// Design Name: 
// Module Name: ALU_bMux
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


module ALU_bMux(
    input ALUSrc,
    input [31:0] ReadData2,
    input [31:0] sigExtImm,
    output [31:0] B
    );
    
    assign B = ALUSrc ? sigExtImm : ReadData2;
    
endmodule
