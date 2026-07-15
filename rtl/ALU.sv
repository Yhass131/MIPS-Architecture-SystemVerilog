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
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [4:0] Shamt,
    input logic [3:0] ALUCntl,
    output logic Zero,
    output logic Overflow,
    output logic Carryout,
    output logic [31:0] ALUout
    );
    
    logic signed [31:0] sig_A;
    logic signed [31:0] sig_B;
    
    always_comb begin
        
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
            4'b1010: ALUout = (sig_A < sig_B);      
            4'b1011: ALUout = (A < B); 
            default: ALUout = '0;
        endcase
        
    end
    
    assign Zero = (ALUout == '0);
    
    logic signed [31:0] sig_ALUout;
    assign sig_ALUout = ALUout;
    assign Overflow = (sig_A > 0 & sig_B > 0 & sig_ALUout < 0) | (sig_A < 0 & sig_B < 0 & sig_ALUout > 0);
    
    logic [32:0] sum33;
    assign sum33 = {1'b0, A} + {1'b0, B};
    assign Carryout = sum33[32]; 
    
endmodule
