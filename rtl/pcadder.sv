`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2026 04:05:25 PM
// Design Name: 
// Module Name: pcadder
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


module pcadder(
    input [31:0] CurrAddr,
    output [31:0] NextAddr
    );
    
    assign NextAddr = CurrAddr + 4;
endmodule
