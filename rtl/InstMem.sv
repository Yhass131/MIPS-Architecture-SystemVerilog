`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2026 06:16:42 PM
// Design Name: 
// Module Name: InstMem
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


module InstMem(
    input [31:0] addr,
    output [31:0] inst_out
    );
    
    logic [31:0] mem [0:63] = '{
        // Test 1: addi - sign extension
        // expect: $t0=5, $t1=15, $t2=0xFFFFFFFF
//        0: 32'h20080005, // 0x00  addi $t0,$zero,5
//        1: 32'h2109000A, // 0x04  addi $t1,$t0,10
//        2: 32'h200AFFFF, // 0x08  addi $t2,$zero,-1
//        3: 32'h08000003, // 0x0C  j    0x0C (halt)

        // Test 2: R-type add/sub
        // expect: $t2=10, $t3=4
        0: 32'h20080007, // 0x00  addi $t0,$zero,7
        1: 32'h20090003, // 0x04  addi $t1,$zero,3
        2: 32'h01095020, // 0x08  add  $t2,$t0,$t1
        3: 32'h01095822, // 0x0C  sub  $t3,$t0,$t1
        4: 32'h08000004, // 0x10  j    0x10 (halt)

        // Test 3: lw  (DataMem must be preloaded 2,3,5,5)
        // expect: $t0=2, $t1=3, $t2=5
//        0: 32'h8C080000, // 0x00  lw $t0,0($zero)
//        1: 32'h8C090004, // 0x04  lw $t1,4($zero)
//        2: 32'h8C0A0008, // 0x08  lw $t2,8($zero)
//        3: 32'h08000003, // 0x0C  j  0x0C (halt)

        // Test 4: sw - write then read back
        // expect: $t1=0x1234, DataMem[8]=0x1234
//        0: 32'h20081234, // 0x00  addi $t0,$zero,0x1234
//        1: 32'hAC080020, // 0x04  sw   $t0,32($zero)
//        2: 32'h8C090020, // 0x08  lw   $t1,32($zero)
//        3: 32'h08000003, // 0x0C  j    0x0C (halt)

        // Test 5: beq - taken, forward
        // expect: $t2=0 (skipped), $t3=1
//        0: 32'h20080005, // 0x00  addi $t0,$zero,5
//        1: 32'h20090005, // 0x04  addi $t1,$zero,5
//        2: 32'h11090001, // 0x08  beq  $t0,$t1,+1 -> 0x10
//        3: 32'h200A0063, // 0x0C  addi $t2,$zero,99   (SKIPPED)
//        4: 32'h200B0001, // 0x10  addi $t3,$zero,1
//        5: 32'h08000005, // 0x14  j    0x14 (halt)

        // Test 6: bne - taken, backward loop 3x
        // expect: $t0=3
//        0: 32'h20080000, // 0x00  addi $t0,$zero,0
//        1: 32'h20090003, // 0x04  addi $t1,$zero,3
//        2: 32'h21080001, // 0x08  loop: addi $t0,$t0,1
//        3: 32'h1509FFFE, // 0x0C  bne  $t0,$t1,-2 -> 0x08
//        4: 32'h08000004, // 0x10  j    0x10 (halt)

        // Test 7: andi
        // expect: $t1=0x0F
//        0: 32'h200800FF, // 0x00  addi $t0,$zero,0x00FF
//        1: 32'h3109000F, // 0x04  andi $t1,$t0,0x000F
//        2: 32'h08000002, // 0x08  j    0x08 (halt)

        // Test 8: ori
        // expect: $t1=0xFF
//        0: 32'h200800F0, // 0x00  addi $t0,$zero,0x00F0
//        1: 32'h3509000F, // 0x04  ori  $t1,$t0,0x000F
//        2: 32'h08000002, // 0x08  j    0x08 (halt)

        // Test 8b: ori - does the immediate zero-extend?
        // real MIPS: $t1=0x0000FFFF   this design: likely 0xFFFFFFFF
//        0: 32'h3409FFFF, // 0x00  ori  $t1,$zero,0xFFFF
//        1: 32'h08000001, // 0x04  j    0x04 (halt)

        // Test 9: slti
        // expect: $t1=1, $t2=0
//        0: 32'h20080005, // 0x00  addi $t0,$zero,5
//        1: 32'h2909000A, // 0x04  slti $t1,$t0,10
//        2: 32'h290A0003, // 0x08  slti $t2,$t0,3
//        3: 32'h08000003, // 0x0C  j    0x0C (halt)

        // Test 10: sltiu vs slti on -1  (signed/unsigned discrimination)
        // expect: $t1=0, $t2=1   (if equal, ALU ignores signedness)
//        0: 32'h2008FFFF, // 0x00  addi  $t0,$zero,-1
//        1: 32'h2D090001, // 0x04  sltiu $t1,$t0,1
//        2: 32'h290A0001, // 0x08  slti  $t2,$t0,1
//        3: 32'h08000003, // 0x0C  j     0x0C (halt)

        // Test 11: addiu - no overflow on wrap
        // expect: $t0=0xFFFFFFFF, $t1=5, Overflow low
//        0: 32'h2408FFFF, // 0x00  addiu $t0,$zero,-1
//        1: 32'h24090005, // 0x04  addiu $t1,$zero,5
//        2: 32'h08000002, // 0x08  j     0x08 (halt)

        // Test 12: j - forward, skips two
        // expect: $t0=1, $t1=7
//        0: 32'h20080001, // 0x00  addi $t0,$zero,1
//        1: 32'h08000004, // 0x04  j    0x10
//        2: 32'h20080063, // 0x08  addi $t0,$zero,99   (SKIPPED)
//        3: 32'h20080063, // 0x0C  addi $t0,$zero,99   (SKIPPED)
//        4: 32'h20090007, // 0x10  addi $t1,$zero,7
//        5: 32'h08000005, // 0x14  j    0x14 (halt)

        // Test 13: jal / jr
        // expect: $ra=0x04, $t1=9, $t0=5
//        0: 32'h0C000003, // 0x00  jal  0x0C      ($ra <- 0x04)
//        1: 32'h20080005, // 0x04  addi $t0,$zero,5   (after return)
//        2: 32'h08000002, // 0x08  j    0x08 (halt)
//        3: 32'h20090009, // 0x0C  SUB:  addi $t1,$zero,9
//        4: 32'h03E00008, // 0x10  jr   $ra -> 0x04

        // Task 1, Lab 6 - multiply routine (original ECE 445 program)
        // DataMem preloaded 2,3,5,5 -> writes 6 and 25 to words 5,6
//         0: 32'h00004020, // 0x00  add  $t0,$zero,$zero
//         1: 32'h00004820, // 0x04  add  $t1,$zero,$zero
//         2: 32'h200A0002, // 0x08  addi $t2,$zero,2
//         3: 32'h200B0014, // 0x0C  addi $t3,$zero,20
//         4: 32'h8D040000, // 0x10  lw   $a0,0($t0)
//         5: 32'h8D050004, // 0x14  lw   $a1,4($t0)
//         6: 32'h0C00000D, // 0x18  jal  MULT (0x34)
//         7: 32'hAD620000, // 0x1C  sw   $v0,0($t3)
//         8: 32'h21080008, // 0x20  addi $t0,$t0,8
//         9: 32'h216B0004, // 0x24  addi $t3,$t3,4
//        10: 32'h21290001, // 0x28  addi $t1,$t1,1
//        11: 32'h152AFFF8, // 0x2C  bne  $t1,$t2,L1
//        12: 32'h08000013, // 0x30  j    DONE (0x4C)
//        13: 32'h00008020, // 0x34  MULT: add  $s0,$zero,$zero
//        14: 32'h00421022, // 0x38  sub  $v0,$v0,$v0
//        15: 32'h00441020, // 0x3C  L2:   add  $v0,$v0,$a0
//        16: 32'h22100001, // 0x40  addi $s0,$s0,1
//        17: 32'h1605FFFD, // 0x44  bne  $s0,$a1,L2
//        18: 32'h03E00008, // 0x48  jr   $ra
//        19: 32'h00000000, // 0x4C  DONE: nop

        default: 32'h00000000
    };
    
    assign inst_out = mem[addr[7:2]];
    
endmodule
