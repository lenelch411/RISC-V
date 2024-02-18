`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2023 17:38:04
// Design Name: 
// Module Name: riscv_core
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


module riscv_core(
input logic clk_i,
input logic rst_i,
input logic stall_i,
input logic [31:0] mem_rd_i,
input logic [31:0] instr_i,
output logic [31:0] instr_addr_o,
//output logic [31:0] data_addr_o,
//output logic [2:0] mem_size_o,
//output logic mem_req_o,
//output logic mem_we_o,
//output logic [31:0] mem_wd_o,
input logic [31:0] data_rdata_i,
input logic [31:0] mcause_i,
input logic INT_i,


output logic data_req_o,
output logic data_we_o,
output logic [3:0] data_be_o,
output logic [31:0] data_addr_o,
output logic [31:0] data_wdata_o,
output logic [31:0] mie_o,
output logic INT_RST_o
    );
     logic [31:0] wb_data;
    // logic branch_o;
     logic jal_o;
     logic [1:0] jalr_o;
     logic [31:0] PC;
     //logic [31:0] res;
     logic [4:0]  alu_op_i;
     logic b;
     logic gpr_we;
     logic mem_req;
     logic mem_we;
     logic [2:0] mem_size;
     logic wb_sel;
     logic [1:0] a_sel;
     logic [2:0] b_sel;
     logic [31:0] RD1 ;
     logic [31:0] RD2 ;
     logic flag_o;
     //logic [5:0] RA1 ;
     //logic [5:0] RA2 ;
     
     logic [31:0] read_data1;
     logic [31:0] read_data2;
    // logic [5:0] WA;
     
     logic [31:0] imm_I;
     logic [31:0] imm_U;
     logic [31:0] imm_S;
     logic [31:0] imm_B;
     logic [31:0] imm_J;    
     
     logic [31:0] a;
     logic [31:0] b_;
     logic [31:0] c;
     
     logic stall;
     logic enpc;
     logic [31:0] data_addr;
     logic [31:0] data_addr1;
     
     logic [31:0] mepc;
     logic [31:0] mtvec;
     logic csr;
     logic [2:0] CSRop_;
     logic [31:0] wb_data0;
     logic [31:0] RD;
     
     assign data_addr1 = data_addr;
     assign instr_addr_o = PC;
     
     //assign data_addr = data_addr_;
     //logic [31:0] data_addr;
     
       
            
         decoder_riscv decoder
        (
        .fetched_instr_i(instr_i),
        .stall_i(stall),
        .a_sel_o(a_sel),
        .b_sel_o(b_sel),
        .alu_op_o(alu_op_i),
        .gpr_we_o(gpr_we),
        .branch_o(b),
        .jal_o(jal_o), 
        .jalr_o(jalr_o), // не переделала jalr_o в 2-х бит
        .mem_req_o(mem_req),
        .mem_we_o(mem_we),
        .mem_size_o(mem_size),
        .wb_sel_o(wb_sel), //write back selector
        .illegal_instr_o(),
        .enpc_o(enpc),
        .csr_o(csr),
        .CSRop(CSRop_),
        .INT_RST(INT_RST_o),
        .int_i(INT_i) 
             
        );
//    assign mem_req_o = mem_req;
//    assign mem_we_o = mem_we;
//    assign mem_size_o = mem_size;
           
        always_comb 
        begin
        imm_I <= {{20{instr_i[31]}}, instr_i[31:20]};
        imm_U <= {instr_i[31:12], 12'h000};
        imm_S <= {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
        imm_B <= {{19{instr_i[31]}}, instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
        imm_J <= {{10{instr_i[31]}}, instr_i[31], instr_i[19:12], instr_i[20], instr_i[31:21], 1'b0};
        end
                
        always_comb 
        begin
            case(a_sel)
            2'b00: read_data1 <= RD1;
            2'b01: read_data1 <= PC;
            2'b10: read_data1 <= 0; 
            endcase
        
            case(b_sel)
            3'b000: read_data2 <= RD2;
            3'b001: read_data2 <= imm_I;
            3'b010: read_data2 <= imm_U;
            3'b011: read_data2 <= imm_S;
            3'b100: read_data2 <= 4;     
            endcase
        end
        
         alu_riscv alu 
        (
        .a_i(read_data1),
        .b_i(read_data2),
        .alu_op_i(alu_op_i),
        .flag_o(flag_o),
        .result_o(data_addr)
        );
        
      
        always_comb 
        begin    
        case(b)
        1'b0: a <= imm_J;
        1'b1: a <= imm_B;
        endcase
        
        case(jal_o || b && flag_o)
        1'b0: b_ <= 4;
        1'b1: b_ <= a;
        endcase
        
        case(jalr_o)
        2'b00: c <= PC + b_;
        2'b01: c <= RD1 + imm_I;
        2'b10: c <= mepc; // mepc не подключен к CSR
        2'b11: c <= mtvec; // mtvec не подключен к CSR
        endcase         
        end

        always_ff @(posedge clk_i) 
        begin
        if(rst_i)
        PC <= 0;
        else
        if(enpc)
        PC <=  PC;
        else
        PC <=  c;  
        end                 
        
        always_comb 
        begin
            case(wb_sel)
            1'b0: wb_data0 <= data_addr;
            1'b1: wb_data0 <= mem_rd_i;
            endcase
        end
        
        always_comb 
        begin
            case(csr)
            1'b0: wb_data <= wb_data0;
            1'b1: wb_data <= RD; 
            endcase
        end        

     rf_riscv rf(
     .clk_i(clk_i),
     .write_enable_i(gpr_we),
     .write_addr_i(instr_i[11:7]),
     .read_addr1_i(instr_i[19:15]),
     .read_addr2_i(instr_i[24:20]),
     .write_data_i(wb_data),
     .read_data1_o(RD1),
     .read_data2_o(RD2)
     
      );
    
    
    assign mem_wd_o = RD2;
 
    
    miriscv_lsu lsu (
                    .clk_i(clk_i),
                    .arstn_i(rst_i),
                    .lsu_addr_i(data_addr1),
                    .lsu_we_i(mem_we),
                    .lsu_size_i(mem_size),
                    .lsu_data_i(RD2),
                    .lsu_req_i(mem_req),
                    .lsu_data_o(mem_rd_i),
                    .lsu_stall_req_o(stall),
                    .data_rdata_i(data_rdata_i),
                    .data_req_o(data_req_o),
                    .data_we_o(data_we_o),
                    .data_be_o(data_be_o),
                    .data_addr_o(data_addr_o),
                    .data_wdata_o(data_wdata_o)); 


    CSR CSR_(
    .clk_i(clk_i),
    .OP_i(CSRop_),
    .A_i(instr_i[31:20]),
    .WD_i(RD1),
    .PC_i(PC),
    .mcause_i(mcause_i),
    .RD_o(RD),
    .mepc_o(mepc),
    .mtvec_o(mtvec),
    .mie_o(mie_o));
    
endmodule