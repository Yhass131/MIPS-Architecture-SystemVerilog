`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2026 08:18:43 PM
// Design Name: 
// Module Name: control
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
                ALUOp    = 3'b010; //Use funct to get exact r-type function
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
                ALUSrc   = 1'b1;    //get word
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
                Branch   = 2'b01; //branch if conparison is equal zero
                ALUOp    = 3'b001; //subtraction to check equvalance, if output is 0, then A=B; otherwise A!=B
            end
            //bne
            6'b000101: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b0;
                MemtoReg = 2'b00;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b10; //branch if conparison isn't equal zero
                ALUOp    = 3'b001; //subtraction to check equvalance, if output is 0, then A=B; otherwise A!=B
            end
            //addi
            6'b001000: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b1; //changes B in ALU to sign extended immidet value form instruction
                MemtoReg = 2'b00;
                RegWrite = 1'b1; //writes to register specified in instruction
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00; 
                ALUOp    = 3'b000; //
            end
            //addiu
            6'b001001: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b1; //changes B in ALU to sign extended immidet value form instruction
                MemtoReg = 2'b00;
                RegWrite = 1'b1; //writes to register specified in instruction
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00; 
                ALUOp    = 3'b011; //cntl for addiu
            end
            //andi
            6'b001100: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b1; //changes B in ALU to sign extended immidet value form instruction
                MemtoReg = 2'b00;
                RegWrite = 1'b1; //writes to register specified in instruction
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00; 
                ALUOp    = 3'b100;//cntl for andi
            end
            //ori
            6'b001101: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b1; //changes B in ALU to sign extended immidet value form instruction
                MemtoReg = 2'b00;
                RegWrite = 1'b1; //writes to register specified in instruction
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00; 
                ALUOp    = 3'b101;//cntl for ori
            end
            //slti
            6'b001010: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b1; //changes B in ALU to sign extended immidet value form instruction
                MemtoReg = 2'b00;
                RegWrite = 1'b1; //writes to register specified in instruction
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00; 
                ALUOp    = 3'b110;//cntl for slti
            end
            //sltiu
            6'b001011: begin
                RegDst   = 2'b00;
                ALUSrc   = 1'b1; //changes B in ALU to sign extended immidet value form instruction
                MemtoReg = 2'b00;
                RegWrite = 1'b1; //writes to register specified in instruction
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 2'b00; 
                ALUOp    = 3'b111;//cntl for sltiu
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
                ALUOp    = 3'b000;//no extra need for ALU due to no caclulations 
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
                ALUOp    = 3'b000; //no extra need for ALU due to no caclulations 
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
    