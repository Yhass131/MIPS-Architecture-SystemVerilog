`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2026 03:55:26 PM
// Design Name: 
// Module Name: pc
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


module pc(
    input logic EN,
    input logic RST,
    input logic CLK,
    input logic [31:0] NextAddr,
    output logic [31:0] CurrAddr
    );
    
    always_ff @(posedge CLK) begin
        if(RST) 
            CurrAddr <= '0;   
        else if(EN)
            CurrAddr <= NextAddr;
    end
    
endmodule
