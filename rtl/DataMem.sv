`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2026 05:56:20 PM
// Design Name: 
// Module Name: DataMem
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


module DataMem(
    input CLK,
    input EN,
    input [31:0] Addr,
    input [31:0] WriteData,
    input MemWrite,
    input MemRead,
    output [31:0] ReadData
    );
    
    logic [31:0] mem [0:63] = '{
    0: 32'h00000002, // 0x00  
    1: 32'h00000003, // 0x04  
    2: 32'h00000005, // 0x08  
    3: 32'h00000005, // 0x0C     
    default: 32'h00000000 };
    
    always_ff @(posedge CLK) begin
        if(EN & MemWrite)
            mem[Addr[6:2]] <= WriteData;
    end
    
    assign ReadData = MemRead ? mem[Addr[6:2]] : 32'h00000000;
endmodule
