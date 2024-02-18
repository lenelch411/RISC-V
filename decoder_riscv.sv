`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2023 11:56:03
// Design Name: 
// Module Name: decoder_riscv
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
package riscv_pkg;

import alu_opcodes_pkg::*;

// opcodes
parameter LOAD_OPCODE     = 5'b00_000;
parameter MISC_MEM_OPCODE = 5'b00_011;
parameter OP_IMM_OPCODE   = 5'b00_100;
parameter AUIPC_OPCODE    = 5'b00_101;
parameter STORE_OPCODE    = 5'b01_000;
parameter OP_OPCODE       = 5'b01_100;
parameter LUI_OPCODE      = 5'b01_101;
parameter BRANCH_OPCODE   = 5'b11_000;
parameter JALR_OPCODE     = 5'b11_001;
parameter JAL_OPCODE      = 5'b11_011;
parameter SYSTEM_OPCODE   = 5'b11_100;

// dmem type load store
parameter LDST_B          = 3'b000;
parameter LDST_H          = 3'b001;
parameter LDST_W          = 3'b010;
parameter LDST_BU         = 3'b100;
parameter LDST_HU         = 3'b101;

// operand a selection
parameter OP_A_RS1        = 2'b00;
parameter OP_A_CURR_PC    = 2'b01;
parameter OP_A_ZERO       = 2'b10;

// operand b selection
parameter OP_B_RS2        = 3'b000;
parameter OP_B_IMM_I      = 3'b001;
parameter OP_B_IMM_U      = 3'b010;
parameter OP_B_IMM_S      = 3'b011;
parameter OP_B_INCR       = 3'b100;

// writeback source selection
parameter WB_EX_RESULT    = 1'b0;
parameter WB_LSU_DATA     = 1'b1;

endpackage

module decoder_riscv(
 input  logic [31:0] fetched_instr_i,
 input logic stall_i,
 input logic int_i,
 output logic [1:0] a_sel_o,
 output logic [2:0] b_sel_o,
 output logic [4:0] alu_op_o,
 output logic mem_req_o,
 output logic mem_we_o,
 output logic [2:0] mem_size_o,
 output logic gpr_we_o,
 output logic wb_sel_o, //write back selector
 output logic illegal_instr_o,
 output logic branch_o,
 output logic jal_o,
 output logic [1:0] jalr_o,
 output logic enpc_o,
 output logic csr_o,
 output logic [2:0] CSRop,
 output logic INT_RST 
);
//initial begin
//mem_req_o <= 0;
//mem_we_o <= 0;
//mem_size_o <= 3'd0;
//wb_sel_o <= 0; 
//gpr_we_o <= 1;
//illegal_instr_o <= 0;
//branch_o <= 0; 
//jal_o <= 0;
//jalr_o <= 0; 
//end
 
 import riscv_pkg::*;
 import alu_opcodes_pkg::*;
 
 assign enpc_o = stall_i;
 
 always_comb begin
 
  csr_o <= 0;
  CSRop <= 3'b000;
  INT_RST <= 0;

//mem_req_o <= 0;
//mem_we_o <= 0;
//mem_size_o <= 3'd0;
//wb_sel_o <= 0; 
//gpr_we_o <= 1;
//illegal_instr_o <= 0;
//branch_o <= 0; 
//jal_o <= 0;
//jalr_o <= 0; 
if (int_i) begin 
        CSRop <= 4;
        jalr_o <= 3;
    end
    else begin
 
 
 case(fetched_instr_i[6:0])
    {LOAD_OPCODE, 2'b11}: begin
    case(fetched_instr_i[14:12])
        3'h0: begin
            a_sel_o <= OP_A_RS1;
            b_sel_o <= OP_B_IMM_I;
            alu_op_o <= ALU_ADD;
            mem_req_o <= 1;
            mem_we_o <= 0;
            mem_size_o <= 3'd0;
            wb_sel_o <= 1;  
            gpr_we_o <= 1;   
            illegal_instr_o <= 0; 
            branch_o <= 0; 
            jal_o <= 0;
            jalr_o <= 0; 
            

         
        end
         3'h1: begin
            a_sel_o <= OP_A_RS1;
            b_sel_o <= OP_B_IMM_I;
            alu_op_o <= ALU_ADD;
            mem_req_o <= 1;
            mem_we_o <= 0;
            mem_size_o <= 3'd1;
            wb_sel_o <= 1;  
            gpr_we_o <= 1;  
            illegal_instr_o <= 0;
            branch_o <= 0; 
            jal_o <= 0;
            jalr_o <= 0;  
            
    
        end
        3'h2: begin
            a_sel_o <= OP_A_RS1;
            b_sel_o <= OP_B_IMM_I;
            alu_op_o <= ALU_ADD;
            mem_req_o <= 1;
            mem_we_o <= 0;
            mem_size_o <= 3'd2;
            wb_sel_o <= 1;  
            gpr_we_o <= 1; 
            illegal_instr_o <= 0;
            branch_o <= 0; 
            jal_o <= 0;
            jalr_o <= 0;     
            

        end
        3'h4: begin
            a_sel_o <= OP_A_RS1;
            b_sel_o <= OP_B_IMM_I;
            alu_op_o <= ALU_ADD;
            mem_req_o <= 1;
            mem_we_o <= 0;
            mem_size_o <= 3'd4;
            wb_sel_o <= 1;  
            gpr_we_o <= 1; 
            illegal_instr_o <= 0; 
            branch_o <= 0; 
            jal_o <= 0;
            jalr_o <= 0;  
            
   
        end
        3'h5: begin
            a_sel_o <= OP_A_RS1;
            b_sel_o <= OP_B_IMM_I;
            alu_op_o <= ALU_ADD;
            mem_req_o <= 1;
            mem_we_o <= 0;
            mem_size_o <= 3'd5;
            wb_sel_o <= 1;  
            gpr_we_o <= 1;
            illegal_instr_o <= 0; 
            branch_o <= 0; 
            jal_o <= 0;
            jalr_o <= 0;
            
     
        end 
                 default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;
                 

                 end 
    endcase
    end
    {MISC_MEM_OPCODE, 2'b11}: begin
    case(fetched_instr_i[14:12])
        3'h0: begin
      illegal_instr_o <= 0;
      end
      default: begin
     illegal_instr_o <= 1;    
     a_sel_o <= 0;
     b_sel_o <= 0;
     alu_op_o <= 0;
     mem_req_o <= 0;
     mem_we_o <= 0;
     mem_size_o <= 0;
     wb_sel_o <= 0;  
     gpr_we_o <= 0;
     branch_o <= 0; 
     jal_o <= 0;
     jalr_o <= 0; 

     end 
     endcase  
    end
    
    {OP_IMM_OPCODE, 2'b11}:begin
        case(fetched_instr_i[14:12])
            3'h0: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_IMM_I;
                alu_op_o <= ALU_ADD;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0; 
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;  
                 
                  
            end
            //---------------------------------
             3'h4: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_IMM_I;
                alu_op_o <= ALU_XOR;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0; 
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;   
                 
                 
            end
             3'h6: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_IMM_I;
                alu_op_o <= ALU_OR;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;  
                 
                     
            end
            3'h7: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_IMM_I;
                alu_op_o <= ALU_AND;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0; 
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;  
                 
                 
            end
            3'h1: begin
                case(fetched_instr_i[31:25]) 
                    2'h00:begin       
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_IMM_I;
                    alu_op_o <= ALU_SLL;
                    mem_req_o <= 0;
                    mem_we_o <= 0;
                    mem_size_o <= 3'd0;
                    wb_sel_o <= 0;  
                    gpr_we_o <= 1;   
                    illegal_instr_o <= 0; 
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;
                  
                    end
                 default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0; 
                  
                 end 
                endcase 
                       
            end
            3'h5: begin
                case(fetched_instr_i[31:25])
                    7'h00:begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_IMM_I;
                    alu_op_o <= ALU_SRL;
                    mem_req_o <= 0;
                    mem_we_o <= 0;
                    mem_size_o <= 3'd0;
                    wb_sel_o <= 0;  
                    gpr_we_o <= 1;   
                    illegal_instr_o <= 0;  
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;  

                    end 
                    7'h20:begin
                    a_sel_o <= OP_A_RS1;
                    b_sel_o <= OP_B_IMM_I;
                    alu_op_o <= ALU_SRA;
                    mem_req_o <= 0;
                    mem_we_o <= 0;
                    mem_size_o <= 3'd0;
                    wb_sel_o <= 0;  
                    gpr_we_o <= 1;   
                    illegal_instr_o <= 0;  
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;  
            
                    end 
                 default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;
                    
                 end 
                 endcase      
            end
            3'h2: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_IMM_I;
                alu_op_o <= ALU_SLTS;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0; 
                      
            end    
            3'h3: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_IMM_I;
                alu_op_o <= ALU_SLTU;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;  
                                       
            end           
    endcase
    end
    {AUIPC_OPCODE, 2'b11}:begin
        a_sel_o <= OP_A_CURR_PC;
        b_sel_o <= OP_B_IMM_U;
        alu_op_o <= ALU_ADD;
        mem_req_o <= 0;
        mem_we_o <= 0;
        mem_size_o <= 3'd0;
        wb_sel_o <= 0;  
        gpr_we_o <= 1;   
        illegal_instr_o <= 0;
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0; 
                 
          
        end
    {STORE_OPCODE, 2'b11}:begin
    case(fetched_instr_i[14:12])
            3'h0: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_IMM_S;
                alu_op_o <= ALU_ADD;
                mem_req_o <= 1;
                mem_we_o <= 1;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 0;   
                illegal_instr_o <= 0; 
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;    
                   
            end
            3'h1: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_IMM_S ;
                alu_op_o <= ALU_ADD;
                mem_req_o <= 1;
                mem_we_o <= 1;
                mem_size_o <= 3'd1;
                wb_sel_o <= 0;  
                gpr_we_o <= 0;   
                illegal_instr_o <= 0;
                 branch_o <= 0; 
                 jal_o <= 0;
                        
            end
            3'h2: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_IMM_S ;
                alu_op_o <= ALU_ADD;
                mem_req_o <= 1;
                mem_we_o <= 1;
                mem_size_o <= 3'd2;
                wb_sel_o <= 0;  
                gpr_we_o <= 0;   
                illegal_instr_o <= 0; 
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;
                       
            end
        default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;
                    
                 end                     
    endcase    
    end       
 //OP_OPCODE
    {OP_OPCODE, 2'b11}:begin
    case(fetched_instr_i[14:12])
        3'h0: begin
            case(fetched_instr_i[31:25])
                7'h00: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_ADD;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;
                

                end    
                7'h20: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_SUB;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;
                
                csr_o <= 0;
                CSRop <= 3'b000;
                INT_RST <= 0;
                end 
                 default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;
                 
                 end              
            endcase            
        end
        3'h4: begin
            case(fetched_instr_i[31:25])
                7'h00: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_XOR;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;

                end
                 default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;

                 end 
            endcase
            end
        3'h6: begin
            case(fetched_instr_i[31:25])
                7'h00: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_OR;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;

                end
                 default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;

                 end  
            endcase
            end            
        3'h7: begin
            case(fetched_instr_i[31:25])
                7'h00: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_AND;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;

                end
                 default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;

                 end 
            endcase
            end             
        3'h1: begin
            case(fetched_instr_i[31:25])
                7'h00: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_SLL;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;

                end
                 default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;

                 end 
            endcase
            end                     
        3'h5: begin
            case(fetched_instr_i[31:25])
                7'h00: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_SRL;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;

                end
                7'h20: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_SRA;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;

                end
                 default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;

                 end 
            endcase
            end         
         3'h2: begin
            case(fetched_instr_i[31:25])
                7'h00: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_SLTS;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;

                end
                 default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;

                 end 
            endcase
            end
        3'h3: begin
            case(fetched_instr_i[31:25])
                7'h00: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_SLTU;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;

                end
                 default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;
                 

                 end 
            endcase
            end
                 default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;

                 end                                
    endcase
    end
   //LUI_OPCODE 
   {LUI_OPCODE, 2'b11}:begin 
                a_sel_o <= OP_A_ZERO;
                b_sel_o <= OP_B_IMM_U;
                alu_op_o <= ALU_ADD;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;
                        
   end
   //BRANCH_OPCODE
    {BRANCH_OPCODE, 2'b11}:begin
    case(fetched_instr_i[14:12])
        3'h0: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_EQ;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 0;   
                illegal_instr_o <= 0;  
                branch_o <= 1; 
                 jal_o <= 0;
                 jalr_o <= 0;
                         
        end
        3'h1: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_NE;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 0;   
                illegal_instr_o <= 0;  
                branch_o <= 1;
                 jal_o <= 0;
                 jalr_o <= 0;
                             
        end
        3'h4: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_LTS;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 0;   
                illegal_instr_o <= 0;  
                branch_o <= 1;
 
                 jal_o <= 0;
                 jalr_o <= 0;
                               
        end
        3'h5: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_GES;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 0;   
                illegal_instr_o <= 0;  
                branch_o <= 1;
                 jal_o <= 0;
                 jalr_o <= 0; 
                      
                      
        end
        3'h6: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_LTU;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 0;   
                illegal_instr_o <= 0;  
                branch_o <= 1;
                 jal_o <= 0;
                 jalr_o <= 0;  
             
        end 
        3'h7: begin
                a_sel_o <= OP_A_RS1;
                b_sel_o <= OP_B_RS2;
                alu_op_o <= ALU_GEU;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 0;   
                illegal_instr_o <= 0;  
                branch_o <= 1; 
                jal_o <= 0;
                jalr_o <= 0;
                              
        end  
                 default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;
                          
                 end               
    endcase
    end
    // JALR_OPCODE   
    {JALR_OPCODE, 2'b11}:begin
    case(fetched_instr_i[14:12])
        3'h0: begin
                a_sel_o <= OP_A_CURR_PC;
                b_sel_o <= OP_B_INCR;
                alu_op_o <= ALU_ADD;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;  
                branch_o <= 0;
                jal_o <= 0;
                jalr_o <= 1;  
         
        end
                 default: begin
                 illegal_instr_o <= 1;    
                 a_sel_o <= 0;
                 b_sel_o <= 0;
                 alu_op_o <= 0;
                 mem_req_o <= 0;
                 mem_we_o <= 0;
                 mem_size_o <= 0;
                 wb_sel_o <= 0;  
                 gpr_we_o <= 0;
                 branch_o <= 0; 
                 jal_o <= 0;
                 jalr_o <= 0;  
                         
                 end  
    endcase        
    end
    
    {JAL_OPCODE, 2'b11}:begin
                a_sel_o <= OP_A_CURR_PC;
                b_sel_o <= OP_B_INCR;
                alu_op_o <= ALU_ADD;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 3'd0;
                wb_sel_o <= 0;  
                gpr_we_o <= 1;   
                illegal_instr_o <= 0;  
                branch_o <= 0;
                jal_o <= 1;
                jalr_o <= 0;
                 
    end 
   //SYSTEM_OPCODE
    // case(fetched_instr_i[14:12])
    {SYSTEM_OPCODE, 2'b11}:begin
    case(fetched_instr_i[14:12]) 
        3'h0: begin
            a_sel_o <= 0;
            b_sel_o <= 0;
            alu_op_o <= 0;
            mem_req_o <= 0;
            mem_we_o <= 0;
            mem_size_o <= 3'd0;
            wb_sel_o <= 0;  
            gpr_we_o <= 0;   
            illegal_instr_o <= 1;  
            branch_o <= 0;
            jal_o <= 0;
            jalr_o <= 2'b10; 
            csr_o <= 0; 
            CSRop <= 3'b000;  
            INT_RST <= 1;        
        end 
        3'h1: begin
            a_sel_o <= 0;
            b_sel_o <= 0;
            alu_op_o <= 0;
            mem_req_o <= 0;
            mem_we_o <= 0;
            mem_size_o <= 3'd0;
            wb_sel_o <= 0;  
            gpr_we_o <= 1;   
            illegal_instr_o <= 1;  
            branch_o <= 0;
            jal_o <= 0;
            jalr_o <= 0; 
            csr_o <= 1;
            CSRop <= 3'b001;
            INT_RST <= 0;             
        end
        3'h2: begin
            a_sel_o <= 0;
            b_sel_o <= 0;
            alu_op_o <= 0;
            mem_req_o <= 0;
            mem_we_o <= 0;
            mem_size_o <= 3'd0;
            wb_sel_o <= 0;  
            gpr_we_o <= 1;   
            illegal_instr_o <= 1;  
            branch_o <= 0;
            jal_o <= 0;
            jalr_o <= 0; 
            csr_o <= 1;
            CSRop <= 3'b011;
            INT_RST <= 0;               
        end
        3'h3: begin
            a_sel_o <= 0;
            b_sel_o <= 0;
            alu_op_o <= 0;
            mem_req_o <= 0;
            mem_we_o <= 0;
            mem_size_o <= 3'd0;
            wb_sel_o <= 0;  
            gpr_we_o <= 1;   
            illegal_instr_o <= 1;  
            branch_o <= 0;
            jal_o <= 0;
            jalr_o <= 0; 
            csr_o <= 1;
            CSRop <= 3'b010;
            INT_RST <= 0;              
        end  
  
    //case(fetched_instr_i[31:7])
               // 0: illegal_instr_o <= 0;
                //8192: illegal_instr_o <= 0;
            default: begin
     illegal_instr_o <= 1;    
     a_sel_o <= 0;
     b_sel_o <= 0;
     alu_op_o <= 0;
     mem_req_o <= 0;
     mem_we_o <= 0;
     mem_size_o <= 0;
     wb_sel_o <= 0;  
     gpr_we_o <= 0;
     branch_o <= 0; 
     jal_o <= 0;
     jalr_o <= 0;

     end 
        
    endcase        
    end 
     
    default: begin
     illegal_instr_o <= 1;    
     a_sel_o <= 0;
     b_sel_o <= 0;
     alu_op_o <= 0;
     mem_req_o <= 0;
     mem_we_o <= 0;
     mem_size_o <= 0;
     wb_sel_o <= 0;  
     gpr_we_o <= 0;
     branch_o <= 0; 
     jal_o <= 0;
     jalr_o <= 0; 


     end 
        


endcase
 end
 end
endmodule
