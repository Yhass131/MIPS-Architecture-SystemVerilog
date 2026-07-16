`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Yunus Hassen
// 
// Create Date: 07/08/2026 08:19:15 PM
// Design Name: MIPS
// Module Name: control
// Project Name: MIPS_inVerilog
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2025.1
// Description:
// Main instruction decoder for the single-cycle MIPS datapath. Decodes
// the 6-bit Opcode into every top-level control signal driving the rest
// of the datapath. For R-type instructions, ALUOp only narrows the
// operation to "R-type" (3'b010) - the specific ALU function is resolved
// downstream by ALUcntl using Funct. For jumps (j/jal), this module has
// no say in whether the PC redirects; that decision belongs entirely to
// jmpLogic, decoded independently from Opcode/Funct.
//
// Inputs:
//   Opcode      - 6-bit instruction opcode field (Instr[31:26])
// Outputs:
//   RegDst      - 2-bit write-register select: 00=Rt, 01=Rd, 10=$ra(31)
//   ALUSrc      - 1-bit ALU B-operand select: 0=register, 1=sign-ext imm
//   MemtoReg    - 2-bit writeback select: 00=ALU result, 01=mem read data,
//                 10=PC+4 (jal)
//   RegWrite    - 1-bit register file write enable
//   MemRead     - 1-bit data memory read enable
//   MemWrite    - 1-bit data memory write enable
//   Branch      - 2-bit branch mode: 00=none, 01=branch on Zero (beq),
//                 10=branch on ~Zero (bne)
//   ALUOp       - 3-bit high-level ALU operation class, refined by ALUcntl
//
// Dependencies: 
// None
//
// Additional Comments:
// andi/ori route ALUSrc=1 the same as every other I-type; the immediate
// is sign-extended by sign_ext regardless of instruction, which deviates
// from the MIPS spec (andi/ori should zero-extend). See README
// "Known Limitations."
// 
//////////////////////////////////////////////////////////////////////////////////


module control(
    input logic [5:0] Opcode,
    
    output logic [1:0] RegDst,
    output logic ALUSrc,
    output logic [1:0] MemtoReg,
    output logic RegWrite,
    output logic MemRead,
    output logic MemWrite,
    output logic [1:0] Branch,
    output logic [2:0] ALUOp
    );
    
    always_comb begin
    
        case(Opcode)
            //R-type
            6'b000000: begin
                RegDst   = 2'b01;  //write to Rd
                ALUSrc   = 1'b0;  
                MemtoReg = 2'b00;  //writeback = ALU result
                RegWrite = 1'b1;  
                MemRead  = 1'b0;  
                MemWrite = 1'b0;  
                Branch   = 2'b00; 
                ALUOp    = 3'b010; //use Funct to resolve exact R-type operation
                end
            //lw
            6'b100011: begin
                RegDst   = 2'b00; //write to Rt
                ALUSrc   = 1'b1;  
                MemtoReg = 2'b01; //writeback = mem data
                RegWrite = 1'b1;  
                MemRead  = 1'b1;  
                MemWrite = 1'b0;  
                Branch   = 2'b00; 
                ALUOp    = 3'b000;
               end
            //sw
            6'b101011: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b1;    //compute effective address
                MemtoReg = 2'b00;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b1;    //write to mem
                Branch   = 2'b00;
                ALUOp    = 3'b000;
            end
            //beq
            6'b000100: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b0;
                MemtoReg = 2'b00;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b01; //branch if comparison equals zero
                ALUOp    = 3'b001; //subtract to check equality: 0 means rs=rt
            end
            //bne
            6'b000101: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b0;
                MemtoReg = 2'b00;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b10; //branch if comparison is not zero
                ALUOp    = 3'b001; //subtract to check equality: 0 means rs=rt
            end
            //addi
            6'b001000: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b1; //route B to sign-extended immediate
                MemtoReg = 2'b00;
                RegWrite = 1'b1; //writes to register specified in instruction
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00; 
                ALUOp    = 3'b000;
            end
            //addiu
            6'b001001: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b1; //route B to sign-extended immediate
                MemtoReg = 2'b00;
                RegWrite = 1'b1; //writes to register specified in instruction
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00; 
                ALUOp    = 3'b011; //ALUcntl code for addiu
            end
            //andi
            6'b001100: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b1; //route B to sign-extended immediate
                MemtoReg = 2'b00;
                RegWrite = 1'b1; //writes to register specified in instruction
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00; 
                ALUOp    = 3'b100; //ALUcntl code for andi
            end
            //ori
            6'b001101: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b1; //route B to sign-extended immediate
                MemtoReg = 2'b00;
                RegWrite = 1'b1; //writes to register specified in instruction
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00; 
                ALUOp    = 3'b101; //ALUcntl code for ori
            end
            //slti
            6'b001010: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b1; //route B to sign-extended immediate
                MemtoReg = 2'b00;
                RegWrite = 1'b1; //writes to register specified in instruction
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00; 
                ALUOp    = 3'b110; //ALUcntl code for slti
            end
            //sltiu
            6'b001011: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b1; //route B to sign-extended immediate
                MemtoReg = 2'b00;
                RegWrite = 1'b1; //writes to register specified in instruction
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00; 
                ALUOp    = 3'b111; //ALUcntl code for sltiu
            end
            //j
            6'b000010: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b0; 
                MemtoReg = 2'b00;
                RegWrite = 1'b0; 
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00; 
                ALUOp    = 3'b000; //ALU unused; jumps are decoded by jmpLogic
            end
            //jal
            6'b000011: begin
                RegDst   = 2'b10; //write to $ra
                ALUSrc   = 1'b0; 
                MemtoReg = 2'b10; //writeback = PC+4
                RegWrite = 1'b1;  //write PC+4 to $ra
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00; 
                ALUOp    = 3'b000; //ALU unused; jumps are decoded by jmpLogic
            end
            default: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b0;
                MemtoReg = 2'b00;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00;
                ALUOp    = 3'b000;
           end
        endcase
    
    end
endmodule