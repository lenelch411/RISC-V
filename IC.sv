`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.12.2023 18:55:57
// Design Name: 
// Module Name: IC
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


module IC(

input logic clk,
input logic [31:0] mie_i,
input logic [31:0] int_req_i,
input logic INT_RST_i,
output logic [31:0] mcause_o,
output logic INT_o,
output logic [31:0] int_fin_o
    );
    logic [31:0] DC;
    logic en;
   // integer i;
    logic [4:0] count = 0;
    logic clock;
    logic [31:0] dc_out;
    
    
        always_ff @(posedge clk) begin
        if (INT_RST_i) count <= 0;
        else begin 
            if (!en) count <= count + 1;
        end
    end
    
    
    
    always_comb begin
        for ( int i=0; i<32; i=i+1 ) begin
            //if (DC[i])
                int_fin_o[i] <= dc_out[i] & INT_RST_i;               
        end           
    end  
    

    
    always_ff @(posedge clk) begin
        if (INT_RST_i) begin
            clock <= 0;
            end 
        else begin 
        clock <= en;                
        end        
    end
    
     assign INT_o = en;
    
     always_comb begin
        DC <= 32'b1; 
     end
    
    assign mcause_o = {27'b0, count};
    assign dc_out = DC & (mie_i & int_req_i);
    assign en = | dc_out;
       // assign en = |(mie_i & int_req_i & DC); 
         
endmodule





 //ADD = {COUT, S};