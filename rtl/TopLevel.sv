`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2026 05:49:28 PM
// Design Name: 
// Module Name: TopLevel
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



module TopLevel(
    input logic CLK,
    input logic EN,
    input logic RST,
    output logic [31:0] Dout,
    output logic [4:0] PCout,
    output logic Zero,
    output logic Overflow,
    output logic Carryout
    );
    
    
    
    

    /*
        ___ First Column ___
    */
    
    logic [31:0] PCAdder;
    logic [31:0] CurrAddr;
    
    logic [31:0] jumpMuxout0;
    logic [31:0] jumpMuxout1;
    
    pc pc0(
        .EN(EN),
        .RST(RST),
        .CLK(CLK),
        .NextAddr(jumpMuxout1),
        .CurrAddr(CurrAddr)
    );
    
    /*
        ___ Second Column ___
    */
    
    logic [31:0] Instr;
    
    InstMem instMem0(
        .addr(CurrAddr),
        .inst_out(Instr)
    );
    
    logic [5:0]  Opcode;
    assign Opcode = Instr[31:26];  // opcode  - all formats
    
    logic [4:0]  rs;
    assign rs = Instr[25:21];  // source reg 1 - R & I
    
    logic [4:0]  rt;
    assign rt = Instr[20:16];  // source reg 2 (R) / dest (I)
    
    logic [4:0]  rd;
    assign rd = Instr[15:11];  // dest reg - R-type only
    
    logic [4:0]  Shamt;
    assign Shamt = Instr[10:6];   // shift amount - R-type shifts
    
    logic [5:0]  Funct;
    assign Funct = Instr[5:0];    // function code - R-type only
    
    logic [15:0] imm;
    assign imm = Instr[15:0];   // immediate/offset - I-type
    
    logic [25:0] jaddr;
    assign jaddr = Instr[25:0];   // jump target field - J-type
    
    pcadder adder0(
        .CurrAddr(CurrAddr),
        .NextAddr(PCAdder)
    );
    
    assign PCout = CurrAddr[6:2];
    
    /*
        ___ Third Column ___
    */
    
    logic [31:0] jTrgtAddr;
    
    JmpTargetAddr jTrgtAddr0(
        .PCAdder(PCAdder),
        .Inst(jaddr),
        .JmpAddr(jTrgtAddr)
    );
    
    logic jumpOut;
    logic jSrc;
    
    jmpLogic jmpLogic0(
        .Opcode(Opcode),
        .Funct(Funct),
        .JmpOut(jumpOut),
        .JmpSrc(jSrc)
    );
    
    logic [1:0] RegDst;
    logic [1:0] Branch;
    logic [2:0] ALUOp;
    logic [1:0] MemtoReg;
    logic       MemWrite, MemRead, ALUSrc, RegWrite;
    
    control cntl0(
        .Opcode(Opcode),
        
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );
    
    logic [4:0] WriteReg;
    
    RegDest regDest0(
        .RegDst(RegDst),
        .Rt(rt),
        .Rd(rd),
        .WReg(WriteReg)
    );
    
    logic [31:0] WriteData;
    logic [31:0] ALU_A;
    
    RegFile RF0(
        .clk(CLK),
        .en(EN),
        .rst(RST),
        .write_en(RegWrite),
        .read_reg1(rs),
        .read_reg2(rt),
        .write_reg(WriteReg),
        .write_data(Dout),
        .read_data1(ALU_A),
        .read_data2(WriteData)
    );
    
    logic [31:0] SignExtImm;
    
    sign_ext SigExt0(
        .Imm(imm),
        .SignExtImm(SignExtImm)
    );
    
    /*
        ___ Forth Column ___
    */
    
    logic [31:0] BrchTargetAddr;
    
    branch_adder BrchAdder(
        .A(PCAdder),
        .B(SignExtImm << 2),
        .Sum(BrchTargetAddr)
    );
    
    logic BranchOut;
    
    branch_logic BrchLogic(
        .Branch(Branch),
        .Zero(Zero),
        .BranchOut(BranchOut)
    );
    
    logic [31:0] ALUOut;
    logic [31:0] ALU_B;
    logic [3:0] ALUCntl;
    
    ALU_bMux bMux0(
        .ALUSrc(ALUSrc),
        .ReadData2(WriteData),
        .sigExtImm(SignExtImm),
        .B(ALU_B)
    );
    
    ALUcntl ALUcntl0(
        .ALUop(ALUOp),
        .Funct(Funct),
        .ALUcntl(ALUCntl)
    );
    
    ALU inst_ALU0(
        .A(ALU_A),
        .B(ALU_B),
        .Shamt(Shamt),
        .ALUCntl(ALUCntl),
        .Zero(Zero),
        .Overflow(Overflow),
        .Carryout(Carryout),
        .ALUout(ALUOut)
    );
    
    /*
        ___ Fifth Column ___
    */
    
    logic [31:0] ReadData;
    
    DataMem DataMem0(
        .CLK(CLK),
        .EN(EN),
        .Addr(ALUOut),
        .WriteData(WriteData),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ReadData(ReadData) 
    );
    
    memToRegMux memToRegMux0(
        .MemToReg(MemtoReg),
        .ALUOut(ALUOut),
        .ReadData(ReadData),
        .PCAdder(PCAdder),
        .WriteData(Dout)
    );
    
    logic [31:0] JumpAddr;
    
    jmpSrcMux jmpSrcMux0(
        .JmpSrc(jSrc),
        .JumpTargetAddr(jTrgtAddr),
        .RFRS(ALU_A),
        .JumpAddr(JumpAddr)
    );
    
    
    mux2to1_32 jumpMux0(
        .A(BrchTargetAddr),
        .B(PCAdder),
        .cntl(BranchOut),
        .out(jumpMuxout0)
    );
    
    
    mux2to1_32 jumpMux1(
        .A(JumpAddr),
        .B(jumpMuxout0),
        .cntl(jumpOut),
        .out(jumpMuxout1)
    );
    
endmodule
