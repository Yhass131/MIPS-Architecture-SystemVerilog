`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2026 04:07:30 PM
// Design Name: 
// Module Name: RegDest
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


module RegDest(
    input [1:0] RegDst,
    input [4:0] Rt,
    input [4:0] Rd,
    output [4:0] WReg
    );
    
    assign WReg =   (RegDst == 2'b00) ? Rt :        //I-type
                    (RegDst == 2'b01) ? Rd :        //R-type
                    (RegDst == 2'b10) ? 5'b11111 :  //for jal
                                        5'b00000;   //$zero, no write, safe default 
    
endmodule
