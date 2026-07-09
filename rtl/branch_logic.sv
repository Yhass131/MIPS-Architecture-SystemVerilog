`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Yunus Hassen
// 
// Create Date: 07/07/2026 07:34:22 PM
// Design Name: 
// Module Name: branch_logic
// Project Name: MIPS in Verilog
// Target Devices: 
// Tool Versions: 
// Description: Uses input 'Branch' to either output 'Zero' or it's inverse through 'BranchOut'.
// 
// Dependencies: N/A
// 
// Revision: 1
// Revision 1 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module branch_logic(
    input logic [1:0] Branch,
    input logic Zero,
    output logic BranchOut
    );
    
    always_comb begin
    
        case(Branch)
            2'b01: BranchOut = Zero;
            2'b10: BranchOut = ~Zero;
            default: BranchOut = '0;
        endcase
    
    end
    
endmodule
