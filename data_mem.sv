`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2023 21:53:25
// Design Name: 
// Module Name: data_mem
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
module data_mem(
  input  logic        clk_i,
  input  logic        mem_req_i,
  input  logic        write_enable_i,
  input  logic [31:0] addr_i,
  input  logic [31:0] write_data_i,
  output logic [31:0] read_data_o
);

  logic [7:0] memory [0:4095]; 
            
  always_ff @(posedge clk_i) begin
  //  if(mem_req_i) begin
           // if(1023 < addr_i < 5116) begin
           if(0 < addr_i < 4092 && mem_req_i == 1 && write_enable_i == 0 )
                read_data_o <= {memory[addr_i+3], memory[addr_i+2], memory[addr_i+1], memory[addr_i]};
                //end
           else
              read_data_o <= 32'hfa11_1eaf;                                                          
  end
  
//   always_ff @(posedge clk_i) begin
//    if(mem_req_i && write_enable_i) begin
//        //if(1023 < addr_i < 5116) begin
//        {memory[addr_i], memory[addr_i + 1], memory[addr_i + 2], memory[addr_i + 3]} <= write_data_i;
//            //end
           
//        end                                 
                  
//    end
    
    always_ff @(posedge clk_i)begin
    
        if(mem_req_i && write_enable_i)begin
            if(1023 < addr_i < 5116)
                {memory[addr_i+3], memory[addr_i+2], memory[addr_i+1], memory[addr_i]} <= write_data_i;
        end
    
    end
    
 endmodule