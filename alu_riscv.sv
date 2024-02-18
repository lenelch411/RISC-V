`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.09.2023 14:14:59
// Design Name: 
// Module Name: alu_riscv
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

package example_pkg;
    
    parameter int DATA_WIDTH = 32;

endpackage

module alu_riscv #(parameter int DATA_WIDTH = 32) (
input  logic [DATA_WIDTH-1:0]  a_i,
input  logic [DATA_WIDTH-1:0]  b_i,
input  logic [4:0]   alu_op_i,
output logic         flag_o,
output logic [DATA_WIDTH-1:0]  result_o
    );
    
import alu_opcodes_pkg::*;
fulladder32 add (.a(a_i), .b(b_i), .carry_in(0), .s(result_o), .carry_out());    
   
always_comb begin
    case(alu_op_i)
    ALU_ADD: result_o <= $signed(a_i) + $signed(b_i);
    ALU_SUB: result_o <= $signed(a_i) - $signed(b_i);
    
    ALU_XOR: result_o <= a_i ^ b_i;
    ALU_OR: result_o <= a_i | b_i;
    ALU_AND: result_o <= a_i & b_i;
    
    ALU_SRA: result_o <= $signed(a_i) >>> b_i[4:0];
    ALU_SRL: result_o <= $signed(a_i) >> b_i[4:0];
    ALU_SLL: result_o <= $signed(a_i) << b_i[4:0];
    
    
    ALU_SLTS: result_o <= $signed(a_i) < $signed(b_i);
    ALU_SLTU: result_o <= a_i < b_i;
    
    default: result_o <= 0;
    endcase
    end
 
 always_comb begin
    case(alu_op_i)
    ALU_LTS: flag_o <= $signed(a_i) < $signed(b_i);
    ALU_LTU: flag_o <= a_i < b_i;
    ALU_GES: flag_o <= $signed(a_i) >= $signed(b_i);
    ALU_GEU: flag_o <= a_i >= b_i;
    ALU_EQ: flag_o <= a_i == b_i;
    ALU_NE: flag_o <= a_i != b_i;
    
    default: flag_o <= 0;
    endcase
    end
endmodule