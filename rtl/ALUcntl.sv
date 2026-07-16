`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
// 
// Create Date: 07/08/2026 08:19:15 PM
// Design Name: MIPS
// Module Name: ALUcntl
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Direct control unit for MIPS ALU. Uses ALUop and funct signal  
// from MIPS control unit to decide ALUcntl signal for ALU.
//
// Inputs:
//   ALUop, Funct               - 3-bit and 6-bit signals form control
// Outputs:
//   ALUcntl                    - 4-bit Signal output for ALU
//
// Dependencies: 
// None
//
// Additional Comments:
// jr falls through to the default ALUcntl = 1111, but this is
// harmless since the ALU isn't used for jr.
//////////////////////////////////////////////////////////////////////////////////


module ALUcntl(
    input logic [2:0] ALUop,
    input logic [5:0] Funct,
    output logic [3:0] ALUcntl
    );
    
    always_comb begin
        
        case(ALUop)
            3'b000: ALUcntl = 4'b0100;  //lw, sw, addi
            3'b001: ALUcntl = 4'b0110;  //beq, bne comparison
            
            3'b010: begin               //R-type, use Funct
                case(Funct)
                    6'b100100: ALUcntl = 4'b0000;   // AND
                    6'b100101: ALUcntl = 4'b0001;   // OR
                    6'b100110: ALUcntl = 4'b0010;   // XOR
                    6'b100111: ALUcntl = 4'b0011;   // NOR
                    6'b100000: ALUcntl = 4'b0100;   // ADD
                    6'b100001: ALUcntl = 4'b0101;   // ADDU
                    6'b100010: ALUcntl = 4'b0110;   // SUB
                    6'b100011: ALUcntl = 4'b0111;   // SUBU
                    6'b000000: ALUcntl = 4'b1000;   // SLL
                    6'b000010: ALUcntl = 4'b1001;   // SRL
                    6'b101010: ALUcntl = 4'b1010;   // SLT
                    6'b101011: ALUcntl = 4'b1011;   // SLTU
                    default: ALUcntl = 4'b1111;     // default
                endcase
            end
            
            3'b011: ALUcntl = 4'b0101;  //addiu
            3'b100: ALUcntl = 4'b0000;  //andi (same ALUcntl as R-type AND)
            3'b101: ALUcntl = 4'b0001;  //ori (same ALUcntl as R-type OR)
            3'b110: ALUcntl = 4'b1010;  // slti
            3'b111: ALUcntl = 4'b1011;  // sltiu
            default: ALUcntl = 4'b1111; // default case
            
        endcase
        
    end
    
endmodule
