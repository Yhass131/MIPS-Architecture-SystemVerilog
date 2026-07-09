`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2026 06:35:19 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] A,
    input [31:0] B,
    input [4:0] Shamt,
    input [3:0] ALUCntl,
    output Zero,
    output Overflow,
    output Carryout,
    output reg [31:0] ALUout
    );
    
    reg signed [31:0] sig_A;
    reg signed [31:0] sig_B;
    
    always @(*) begin
        
        sig_A = A;
        sig_B = B;
        case(ALUCntl)
            4'b0000: ALUout = A & B;
            4'b0001: ALUout = A | B;
            4'b0010: ALUout = A ^ B;
            4'b0011: ALUout = ~(A | B);
            4'b0100: ALUout = A + B;
            4'b0101: ALUout = sig_A + sig_B;
            4'b0110: ALUout = A - B;
            4'b0111: ALUout = sig_A - sig_B;
            4'b1000: ALUout = B << Shamt;
            4'b1001: ALUout = B >> Shamt;
            4'b1010: ALUout = (A < B)? 1'b1 : 1'b0;
            4'b1011: ALUout = (sig_A < sig_B)? 1'b1 : 1'b0;
        endcase
        
    end
    
    
endmodule
