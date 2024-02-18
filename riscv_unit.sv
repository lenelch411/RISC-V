`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2023 22:30:43
// Design Name: 
// Module Name: riscv_unit
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



module riscv_unit#(
  parameter RAM_SIZE      = 256, // bytes
  parameter RAM_INIT_FILE = ""
)(
    input logic clk_i,
    input logic rst_i,
    //output logic  [31:0] PC,
    output logic [31:0]mem_wd_o,
    output logic [31:0] data_addr_o,
    output logic [31:0] instr_addr_o,
    output logic [31:0] MEM_RD_I
    );
    
    logic [31:0] instr_i;
    logic [31:0] mem_rd_i;
    
    //memory protocol
    logic [31:0] data_rdata;
    logic data_req;
    logic data_we;        
    logic [3:0] data_be;   
    logic [31:0] data_addr;
    logic [31:0] data_wdata;
    
    
    assign MEM_RD_I = mem_rd_i;
    
    logic stall;
    logic mem_we_o;
    logic mem_req_o;
    logic stall_i;
    
   
    assign stall_i = ~stall & mem_req_o;
   
    riscv_core core(.clk_i(clk_i),
                    .rst_i(rst_i),
                    .stall_i(stall_i),
                    
                    // instruction memory interface
                    .instr_i(instr_i),
                    .instr_addr_o(instr_addr_o),
                    
                    //memory protocol
                    .data_rdata_i(data_rdata),
                    .data_req_o(data_req),
                    .data_we_o(data_we),
                    .data_be_o(data_be),
                    .data_addr_o(data_addr),
                    .data_wdata_o(data_wdata)
                    );
                    
    miriscv_ram rm(
                    .clk_i(clk_i),
                    .rst_n_i(rst_i),
                    .instr_rdata_o(instr_i),
                    .instr_addr_i(instr_addr_o),
                    .data_rdata_o(data_rdata),
                    .data_req_i(data_req),
                    .data_we_i(data_we),
                    .data_be_i(data_be),
                    .data_addr_i(data_addr),
                    .data_wdata_i(data_wdata)
    );
            
endmodule
