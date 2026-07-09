`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2026 04:57:40 PM
// Design Name: 
// Module Name: JmpTargetAddr
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


module JmpTargetAddr(
    input [31:0] PCAdder,
    input [25:0] Inst,
    output [31:0] JmpAddr
    );
    
    assign JmpAddr = {PCAdder[31:28], Inst, 2'b00};
    
endmodule
