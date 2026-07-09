`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2026 04:46:26 PM
// Design Name: 
// Module Name: jmpSrcMux
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


module jmpSrcMux(
    input JmpSrc,
    input [31:0] JumpTargetAddr,
    input [31:0] RFRS,
    output [31:0] JumpAddr
    );
    
    assign JumpAddr = JmpSrc ? RFRS : JumpTargetAddr;
    
endmodule
