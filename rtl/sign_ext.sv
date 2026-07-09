`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2026 04:15:11 PM
// Design Name: 
// Module Name: sign_ext
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


module sign_ext(
    input [15:0] Imm,
    output [31:0] SignExtImm
    );
    
    assign SignExtImm = { {16{Imm[15]}} , Imm };
    
endmodule
