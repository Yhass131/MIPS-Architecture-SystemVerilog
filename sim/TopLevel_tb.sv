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


module TopLevel_tb(

    );
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
    
    //Clock cycle with a 10ps period
    initial begin clk = 0; end
    always begin #5 clk = ~clk; end
    
    initial begin
        en = 1;
        rst = 1;
        #10 rst = 0;
        $display("$t0=%0d  $t1=%0d  $t2=%h",
             Top.RF0.RAM[8],
             Top.RF0.RAM[9],
             Top.RF0.RAM[10]);
        #1000 $finish;    
    end
    
    initial begin
        $monitor("t=%0t  PC=%h  Dout=%h  Z=%b", $time, PCout, Dout, z);
    end
endmodule
