`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2026 06:57:18 PM
// Design Name: 
// Module Name: ALUcntl
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


module ALUcntl(
    input [2:0] ALUop,
    input [5:0] Funct,
    output logic [3:0] ALUcntl
    );
    
    always_comb begin
        
        case(ALUop)
            3'b000: ALUcntl = 4'b0100; //lw, sw, addi
            3'b001: ALUcntl = 4'b0110; //beq, bne comparison
            
            3'b010: begin
                case(Funct)
                    6'b100100: ALUcntl = 4'b0000; // AND
                    6'b100101: ALUcntl = 4'b0001; // OR
                    6'b100110: ALUcntl = 4'b0010; // XOR
                    6'b100111: ALUcntl = 4'b0011; // NOR
                    6'b100000: ALUcntl = 4'b0100; // ADD
                    6'b100001: ALUcntl = 4'b0101; // ADDU
                    6'b100010: ALUcntl = 4'b0110; // SUB
                    6'b100011: ALUcntl = 4'b0111; // SUBU
                    6'b000000: ALUcntl = 4'b1000; // SLL
                    6'b000010: ALUcntl = 4'b1001; // SRL
                    6'b101010: ALUcntl = 4'b1010; // SLT
                    6'b101011: ALUcntl = 4'b1011; // SLTU
                    default: ALUcntl = 4'b1111;
                endcase;
            end
            
            3'b011: ALUcntl = 4'b0101; //addiu
            3'b100: ALUcntl = 4'b0000; //andi
            3'b101: ALUcntl = 4'b0001; //ori
            3'b110: ALUcntl = 4'b1010; // slti
            3'b111: ALUcntl = 4'b1011; // sltiu
            default: ALUcntl = 4'b1111;
            
        endcase
        
    end
    
endmodule
