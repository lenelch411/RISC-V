`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.09.2023 15:02:57
// Design Name: 
// Module Name: fulladder32
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


module fulladder32(
    input [31:0] a,
    input [31:0] b,
    input carry_in,
    output [31:0] s,
    output carry_out
    );
    logic [32:0] carry;
    genvar i;
    generate
        assign carry[0] = carry_in;
        for(i = 0; i < 32; i = i + 1) begin: newgen
        fulladder add(
            .a_i(a[i]),
            .b_i(b[i]),
            .carry_i(carry[i]),
            .sum_o(s[i]),
            .carry_o(carry[i+1])
        );
        assign carry[32] = carry_out;
        end
   endgenerate
endmodule