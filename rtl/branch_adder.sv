`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2026 07:28:51 PM
// Design Name: 
// Module Name: branch_adder
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


module branch_adder(
    input [31:0] A,
    input [31:0] B,
    output [31:0] Sum
    );
    
    assign Sum = A + B;
    
endmodule
