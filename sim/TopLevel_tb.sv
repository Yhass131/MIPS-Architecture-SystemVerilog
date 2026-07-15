`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2026 01:27:09 PM
// Design Name: 
// Module Name: TopLevel_tb
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
`timescale 1ns / 1ps

module TopLevel_tb(
    );
    int pass_count = 0;
    int fail_count = 0;
    
    logic clk, en, rst, z, of, co;
    logic [31:0] Dout;
    logic [4:0] PCout;
    
    TopLevel Top(
        .CLK(clk),
        .EN(en),
        .RST(rst),
        .Dout(Dout),
        .PCout(PCout),
        .Zero(z),
        .Overflow(of),
        .Carryout(co)
    );
    
    // 100 MHz
    initial clk = 0; 
    always #5 clk = ~clk;
    
    task automatic check(string name, logic [31:0] actual, logic [31:0] expected);
        if (actual !== expected) begin
            $display("[FAIL] %-24s got %h, expected %h", name, actual, expected);
            fail_count++;
        end else begin
            $display("[PASS] %-24s = %h", name, actual);
            pass_count++;
        end
    endtask
    
    // loads a new program, resets, and lets it run
    task automatic run_program(string instr_hex, string data_hex = "");
        rst = 1;
        Top.instMem0.mem = '{default: '0};     // ← add this
        $readmemh(instr_hex, Top.instMem0.mem);
        if (data_hex != "")
            $readmemh(data_hex, Top.DataMem0.mem);
        else
            Top.DataMem0.mem = '{default: '0};
        @(posedge clk); @(negedge clk);
        rst = 0;
        repeat (200) @(posedge clk);
    endtask
    
    // hierarchical shorthands
    `define REG(n) Top.RF0.RAM[n]
    `define MEM(n) Top.DataMem0.mem[n]
    `define DIR "C:/Users/yunus/Mason/Spring 26/ECE 445/MIPS_inVerilog/tests/"
    `define DATA "C:/Users/yunus/Mason/Spring 26/ECE 445/MIPS_inVerilog/data_2_3_5_5.hex"

    initial begin
        en  = 1;

        // ============================================
        // Test 1: addi - sign extension
        // ============================================
        run_program({`DIR, "test1.hex"});
        $display("\n=== Test 1: addi - sign extension ===");
        check("test01 $t0", `REG(8),  32'd5);
        check("test01 $t1", `REG(9),  32'd15);
        check("test01 $t2", `REG(10), 32'hFFFFFFFF);

        // ============================================
        // Test 2: R-type add/sub
        // ============================================
        run_program({`DIR, "test2.hex"});
        $display("\n=== Test 2: R-type add/sub ===");
        check("test02 $t2", `REG(10), 32'd10);
        check("test02 $t3", `REG(11), 32'd4);

        // ============================================
        // Test 3: lw
        // ============================================
        run_program({`DIR, "test3.hex"}, `DATA);
        $display("\n=== Test 3: lw ===");
        check("test03 $t0", `REG(8),  32'd2);
        check("test03 $t1", `REG(9),  32'd3);
        check("test03 $t2", `REG(10), 32'd5);

        // ============================================
        // Test 4: sw - write then read back
        // ============================================
        run_program({`DIR, "test4.hex"});
        $display("\n=== Test 4: sw ===");
        check("test04 $t1",    `REG(9), 32'h00001234);
        check("test04 mem[8]", `MEM(8), 32'h00001234);

        // ============================================
        // Test 5: beq - taken, forward
        // ============================================
        run_program({`DIR, "test5.hex"});
        $display("\n=== Test 5: beq (taken, forward) ===");
        check("test05 $t2", `REG(10), 32'd0);
        check("test05 $t3", `REG(11), 32'd1);

        // ============================================
        // Test 6: bne - taken, backward loop
        // ============================================
        run_program({`DIR, "BackwardLoop.hex"});
        $display("\n=== Test 6: bne (backward loop) ===");
        check("test06 $t0", `REG(8), 32'd3);

        // ============================================
        // Test 7: andi
        // ============================================
        run_program({`DIR, "test7.hex"});
        $display("\n=== Test 7: andi ===");
        check("test07 $t1", `REG(9), 32'h0000000F);

        // ============================================
        // Test 8: ori
        // ============================================
        run_program({`DIR, "test8.hex"});
        $display("\n=== Test 8: ori ===");
        check("test08 $t1", `REG(9), 32'h000000FF);

        // ============================================
        // Test 9: slti
        // ============================================
        run_program({`DIR, "test9.hex"});
        $display("\n=== Test 9: slti ===");
        check("test09 $t1", `REG(9),  32'd1);
        check("test09 $t2", `REG(10), 32'd0);

        // ============================================
        // Test 10: sltiu vs slti - signed/unsigned
        // ============================================
        run_program({`DIR, "Sig_Unsig.hex"});
        $display("\n=== Test 10: sltiu vs slti ===");
        check("test10 $t1 (sltiu)", `REG(9),  32'd0);
        check("test10 $t2 (slti)",  `REG(10), 32'd1);

        // ============================================
        // Test 11: addiu - no overflow on wrap
        // ============================================
        run_program({`DIR, "test11.hex"});
        $display("\n=== Test 11: addiu ===");
        check("test11 $t0", `REG(8), 32'hFFFFFFFF);
        check("test11 $t1", `REG(9), 32'd5);

        // ============================================
        // Test 12: j - forward, skips two
        // ============================================
        run_program({`DIR, "test12.hex"});
        $display("\n=== Test 12: j ===");
        check("test12 $t0", `REG(8), 32'd1);
        check("test12 $t1", `REG(9), 32'd7);

        // ============================================
        // Test 13: jal / jr
        // ============================================
        run_program({`DIR, "JumpMuxes.hex"});
        $display("\n=== Test 13: jal / jr ===");
        check("test13 $ra", `REG(31), 32'h00000004);
        check("test13 $t1", `REG(9),  32'd9);
        check("test13 $t0", `REG(8),  32'd5);

        // ============================================
        // Multiply routine - integration test
        // expect: mem[5]=6, mem[6]=25, $ra=0x1C
        // NOTE: jal is at word 6 (byte 0x18) -> $ra should be 0x1C.
        // If this fails against 0x11C instead, that's a real bug in
        // PCAdder/MemtoReg, not a wrong expected value - investigate
        // the waveform before changing this constant.
        // ============================================
        run_program({`DIR, "multiply.hex"}, `DATA);
        $display("\n=== Multiply routine ===");
        check("mem[5] = 2 * 3", `MEM(5), 32'd6);
        check("mem[6] = 5 * 5", `MEM(6), 32'd25);
        check("$ra",            `REG(31), 32'h0000001C);

        $finish;
    end
    
    final begin
        $display("\n=====================================");
        $display("  %0d passed, %0d failed", pass_count, fail_count);
        $display("  %s", (fail_count == 0) ? "ALL 14 TESTS PASSED" : "FAILURES PRESENT");
        $display("=====================================");
    end
endmodule