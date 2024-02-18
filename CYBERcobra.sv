`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.09.2023 00:59:20
// Design Name: 
// Module Name: CYBERcobra
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

module CYBERcobra(
input logic clk_i,
input logic rst_i,
input logic [15:0] sw_i,
output logic [31:0] out_o
    );
    logic [31:0] read_data_o;
    
    logic [31:0] PC_o;
    logic [31:0] res;

    logic [31:0] read_data1_o ;
    logic [31:0] read_data2_o ;
    logic [31:0] result_o ;
    logic [4:0]  alu_op_i;
    logic        flag_o;
    logic        write_enable_i;
    
    
    logic [31:0] b;
    logic [31:0] ws;
    
    assign write_enable_i = ~(read_data_o[30] || read_data_o[31]);
    
    assign out_o = read_data1_o;

    
    always_comb 
    begin
    case(read_data_o[29:28])
    2'b00 : ws <= { {9{read_data_o[27]}} , read_data_o[27:5] };
    2'b01 : ws <= result_o;
    2'b10 : ws <={ {16{sw_i[15]}} , sw_i[15:0] };
    2'b11 : ws <=32'd0;
    endcase
    end
    
    rf_riscv rf(
 .clk_i(clk_i),
 .write_enable_i(write_enable_i),
 .write_addr_i(read_data_o[4:0]),
 .read_addr1_i(read_data_o[22:18]),
 .read_addr2_i(read_data_o[17:13]),
 .write_data_i(ws),
 .read_data1_o(read_data1_o),
 .read_data2_o(read_data2_o)
  );
  
  assign alu_op_i = read_data_o[27:23];
  
  
      alu_riscv alu 
    (
    .a_i(read_data1_o),
    .b_i(read_data2_o),
    .alu_op_i(alu_op_i),
    .flag_o(flag_o),
    .result_o(result_o)
    );
    
    instr_mem instr
    (
    .addr_i(PC_o),
    .read_data_o(read_data_o)
    );
    
   fulladder32 add(
            .a(PC_o),
            .b(b),
            .carry_in(0),
            .s(res),
            .carry_out()
        );
    
    always_ff @(posedge clk_i) 
    begin
    if(rst_i)
    PC_o <= 0;
    else 
    
    PC_o <= res;
    end
    
    always_comb 
    begin
    if((flag_o && read_data_o[30]) || read_data_o[31] )
    b = { {22{read_data_o[12]}} , read_data_o[12:5] , 2'b0 };
    else b = 32'd4;
    end
    
    
    
endmodule