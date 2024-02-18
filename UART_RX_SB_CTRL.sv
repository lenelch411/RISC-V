`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.12.2023 13:04:10
// Design Name: 
// Module Name: UART_RX_SB_CTRL
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


module UART_RX_SB_CTRL(
/*
    Часть интерфейса модуля, отвечающая за подключение к системной шине
*/
  input  logic          clk_i,
  input  logic          rst_i,
  input  logic [31:0]   addr_i,
  input  logic          req_i,
  input  logic [31:0]   write_data_i,
  input  logic          write_enable_i,
  output logic [31:0]   read_data_o,
  output logic [31:0] int_req,

/*
    Часть интерфейса модуля, отвечающая за подключение передающему,
    входные данные по UART
*/
  input  logic          rx_i
);

  logic busy;
  logic [31:0] baudrate;
  logic parity_en;
  logic stopbit;
  logic [7:0] data;
  logic valid;
  
          UART_RX uart_rx(
     .clk_i(clk_i),
     .rst_i(rst_i),
     .rx_i(rx_i),
     .busy_o(busy),
     .baudrate_i(baudrate),
     .parity_en_i(parity_en),
     .stopbit_i(stopbit),
     .rx_data_o(data),
     .rx_valid_o(valid)
    );

    assign int_req = {31'b0, valid};
  
    
    
    always_ff @(posedge clk_i) begin
        if (rst_i | (addr_i == 32'h24 & req_i & write_enable_i)) begin
            baudrate <= 9600;
            parity_en <= 1;
            stopbit <= 1;
            busy <= 0;
            data <= 0;
            valid <= 0;            
        end        
  end
  
    always_comb begin
        read_data_o <= 0;
        if (req_i & !write_enable_i) begin
            case(addr_i)
                32'h0: begin
                    read_data_o <= {24'b0, data};
                    //valid <= 0;
                end
                32'h4: read_data_o <= {31'b0, valid};
                32'h8: read_data_o <= {31'b0, busy};
                32'hC: read_data_o <= {16'b0, baudrate};
                32'h10: read_data_o <= {31'b0, parity_en};
                32'h14: read_data_o <= {31'b0, stopbit};                              
            endcase    
        end
    end
    
    always_ff @(posedge clk_i) begin
        if (req_i & write_enable_i) begin
            if (!busy)
            case(addr_i) 
                32'hC: baudrate <= write_data_i;
                32'h10: parity_en <= write_data_i[0];
                32'h14: stopbit <= write_data_i[0];                
            endcase         
        end    
   end

endmodule
