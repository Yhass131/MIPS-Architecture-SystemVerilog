`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2026 04:49:34 PM
// Design Name: 
// Module Name: jmpLogic
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


module jmpLogic(
    input [5:0] Opcode,
    input [5:0] Funct,
    output JmpOut,
    output JmpSrc
    );
    
    assign JmpOut = (Opcode == 6'b000010) ? 1'b1 :                              //j
                    (Opcode == 6'b000011) ? 1'b1 :                              //jal
                    ( (Opcode == 6'b000000) & (Funct == 6'b001000) ) ? 1'b1 :   //jr
                    1'b0;                                                       //no jump
   
   assign JmpSrc = ( (Opcode == 6'b000000) & (Funct == 6'b001000) ) ? 1'b1  : 1'b0; //Select RF[RS] only for jr
    
endmodule
