`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2023 14:44:08
// Design Name: 
// Module Name: CSR
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


module CSR(
input logic clk_i,
input logic [2:0] OP_i,
input logic [11:0] A_i,
input logic [31:0] WD_i,
input logic [31:0] PC_i,
input logic [31:0] mcause_i,
output logic [31:0] RD_o,

output logic [31:0] mepc_o,
output logic [31:0] mtvec_o,
output logic [31:0] mie_o
    );
    logic OP_1_2;
    logic [31:0] wd;
    //logic [31:0] OP;
    logic en_304;
    logic en_305;
    logic en_340;
    logic en_341;
    logic en_342;
    
    logic [31:0] RD_41;
    logic [31:0] RD_42;
    
    logic [31:0] mscr;
    logic [31:0] mcause_reg;

    assign OP_1_2 = OP_i [1] | OP_i [2]; 
    
    always_comb begin
    case(OP_i [1:0])
    0: wd <= 32'b0;
    1: wd <= WD_i;
    2: wd <= (!WD_i & RD_o);
    3: wd <= RD_o | WD_i;
    endcase 
    end
    
    
        always_comb begin
        en_304 <= 0;
        en_305 <= 0;
        en_340 <= 0;
        en_341 <= 0;
        en_342 <= 0;
        case(A_i)
            12'h304: en_304 <= OP_i [1] | OP_i [0];
            12'h305: en_305 <= OP_i [1] | OP_i [0];
            12'h340: en_340 <= OP_i [1] | OP_i [0];
            12'h341: en_341 <= OP_i [1] | OP_i [0];
            12'h342: en_342 <= OP_i [1] | OP_i [0];
        endcase 
    end
    
    
    always_comb begin
        case(OP_i[2])
            1: RD_41 <= PC_i;
            0: RD_41 <= wd;
        endcase
    end
    
    always_comb begin
        case(OP_i[2])
            1: RD_42 <= mcause_i;
            0: RD_42 <= wd;
        endcase
    end
    
    always_ff @(posedge clk_i) begin
        if (en_304) mie_o <= wd;
        if (en_305) mtvec_o <= wd;
        if (en_340) mscr <= wd;
        if (en_341 || OP_i[2]) mepc_o <= RD_41;
        if (en_342 || OP_i[2]) mcause_reg <= RD_42;
    end
    
    always_comb begin
        case(A_i)
            12'h304: RD_o <= mie_o;
            12'h305: RD_o <= mtvec_o;
            12'h340: RD_o <= mscr;
            12'h341: RD_o <= mepc_o;
            12'h342: RD_o <= mcause_reg;
        endcase
    end
    
    //assign RD = RD_out;
    
    
//    always_ff @(posedge clk_i) begin  
//    case(A_i)
//    12'b0000000100: begin
//        if(OP_1_2) begin
//            RD_o <= wd;
//            mie_o <= wd;
//        end     
//    end
//    12'b0000000101: begin
//        if(OP_1_2) begin
//            RD_o <= wd;
//            mtvec_o <= wd;
//        end        
//    end
//    12'b0001000000: begin
//        if(OP_1_2)
//            RD_o <= wd;
//    end
//    12'b0001000001: begin
//        if(OP_1_2 | OP_i [2]) begin
//            case(OP_i [2])
//            0: RD_o <= wd;
//            1: RD_o <= PC_i;
//            endcase
//            mepc_o <= RD_o;
//        end
//    end
//    12'b0001000010: begin
//        if(OP_1_2 | OP_i [2]) begin
//            case(OP_i [2])
//            0: RD_o <= wd;
//            1: RD_o <= mcause_i;
//            endcase
//        end            
//    end
    
//    endcase
//    end
    
endmodule
