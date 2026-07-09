`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2026 05:35:03 PM
// Design Name: 
// Module Name: memToRegMux
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


module memToRegMux(
    input logic [1:0] MemToReg,
    input logic [31:0] ALUOut,
    input logic [31:0] ReadData,
    input logic [31:0] PCAdder,
    output logic [31:0] WriteData
    );
    
    
    always_comb begin
        case (MemToReg)
              2'b00: WriteData = ALUOut;     //ALU result
              2'b01: WriteData = ReadData;   //Data Memory
              2'b10: WriteData = PCAdder;    //PC+4 for jal
              default: WriteData = '0;      //default
       endcase
    end                          
    
endmodule
