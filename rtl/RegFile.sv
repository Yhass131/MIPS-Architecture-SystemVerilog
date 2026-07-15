`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2026 07:08:13 PM
// Design Name: 
// Module Name: RegFile
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


module RegFile(
    input clk,
    input en,
    input rst,
    input write_en,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
    );
    
    logic [31:0] RAM [0:31];
    
    always_ff @(posedge clk) begin
        if(rst)
            RAM <= '{default: 0};
        else if ( en && write_en  && write_reg != 5'b00000 )
            RAM[write_reg] <= write_data;
    end
    
    assign read_data1 = (read_reg1 == '0) ? '0 : RAM[read_reg1];
    assign read_data2 = (read_reg2 == '0) ? '0 : RAM[read_reg2];
endmodule
