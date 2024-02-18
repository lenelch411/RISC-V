`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.09.2023 15:00:18
// Design Name: 
// Module Name: fulladder
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


module fulladder(
    input  logic [31:0] a_i,
    input  logic [31:0] b_i,
    input  logic        carry_i,
    output logic [31:0] sum_o,
    output logic        carry_o
);
    assign sum_o = a_i^b_i^carry_i;
    assign carry_o = a_i&b_i|carry_i&a_i|b_i&carry_i;
    
endmodule