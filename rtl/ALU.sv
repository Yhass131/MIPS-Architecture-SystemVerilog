`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
// 
// Create Date: 07/08/2026 08:19:15 PM
// Design Name: MIPS
// Module Name: ALU
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Arithmetic Logic Unit for a single-cycle MIPS processor. Selects one of
// 12 combinational operations (AND, OR, XOR, NOR, ADD, SUB, SLL, SRL, SLT,
// SLTU, plus signed ADD/SUB variants) based on ALUCntl, driven by the
// separate ALUcntl module.
//
// Inputs:
//   A, B      - 32-bit operands
//   Shamt     - 5-bit shift amount, used only by SLL/SRL
//   ALUCntl   - 4-bit operation select from ALUcntl
// Outputs:
//   ALUout    - 32-bit result
//   Zero      - ALUout == 0 (drives branch comparisons)
//   Overflow  - signed add/sub overflow
//   Carryout  - carry out of A + B
//
// Dependencies: 
// None
//
// Additional Comments:
// Overflow and Carryout are computed unconditionally from A/B
// regardless of the active operation - only meaningful to read during
// ADD/SUB. No arithmetic right shift (SRA) is implemented.
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
            4'b0000: ALUout = A & B;            // and
            4'b0001: ALUout = A | B;            // or
            4'b0010: ALUout = A ^ B;            // xor
            4'b0011: ALUout = ~(A | B);         // nor
            4'b0100: ALUout = A + B;            // add
            4'b0101: ALUout = sig_A + sig_B;    // addu
            4'b0110: ALUout = A - B;            // sub
            4'b0111: ALUout = sig_A - sig_B;    // subu
            4'b1000: ALUout = B << Shamt;       // sll
            4'b1001: ALUout = B >> Shamt;       // srl
            4'b1010: ALUout = (sig_A < sig_B);  // slt    
            4'b1011: ALUout = (A < B);          // sltu
            default: ALUout = '0;               // default case
        endcase
        
    end

    //========= Zero Flag =========
    assign Zero = (ALUout == '0);
    
    //========= Overflow Flag =========
    logic signed [31:0] sig_ALUout;
    assign sig_ALUout = ALUout;
    assign Overflow = (sig_A > 0 & sig_B > 0 & sig_ALUout < 0) | (sig_A < 0 & sig_B < 0 & sig_ALUout > 0);
    
    //========= Carryout Flag =========
    logic [32:0] sum33;
    assign sum33 = {1'b0, A} + {1'b0, B};
    assign Carryout = sum33[32]; 
    
endmodule
