`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2023 17:45:21
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


module riscv_unit(
input logic clk_i,
input logic rstn_i, //сброс по уровню 0


//output logic [31:0] mem_wd_o,
output logic [31:0] data_addr_o,
output logic [31:0] instr_addr_o,

  // Входы и выходы периферии
  input  logic [15:0] sw_i,       // Переключатели
  output logic [15:0] led_o,      // Светодиоды
  input  logic        kclk_i,     // Тактирующий сигнал клавиатуры
  input  logic        kdata_i,    // Сигнал данных клавиатуры
  output logic [ 6:0] hex_led_o,  // Вывод семисегментных индикаторов
  output logic [ 7:0] hex_sel_o,  // Селектор семисегментных индикаторов
  input  logic        rx_i,       // Линия приема по UART
  output logic        tx_o        // Линия передачи по UART
  

//output logic [31:0] mem_rd
    );
//logic [31:0] instr_addr_o;
logic mem_req_o;
logic mem_we_o;
//logic [2:0] mem_size_o;
logic [31:0] instr_i; 
logic stall;
logic stall_i;

logic [31:0] data_rdata;
logic data_req;
logic data_we;        
logic [3:0] data_be;   
logic [31:0] data_addr;
logic [31:0] data_wdata;

logic [31:0] mie;
//logic [31:0] int_req_;
logic INT_RST;
logic [31:0] mcause;
logic INT_;

logic [7:0] periph_req;
logic [7:0] periph_addr;
logic [31:0] data_addr;
logic req_i;
logic [31:0] read_data_rx;
logic [31:0] read_data_tx;
logic [31:0] read_data_mem;

logic [31:0] read_data;
logic [31:0] int_req_i;
logic sysclk, rst;
sys_clk_rst_gen divider(.ex_clk_i(clk_i),.ex_areset_n_i(rstn_i),.div_i(10),.sys_clk_o(sysclk), .sys_reset_o(rst));
//logic [31:0] int_fin_o;

assign periph_addr = data_addr[31:24];
//assign data_addr = {8'd0, data_addr_o[23:0]};

always_comb begin
    periph_req <= 7'b0;
    periph_req[periph_addr] <= 1;
end 

always_comb begin
    case(data_addr[31:24])
        0: read_data <= read_data_mem;
        5: read_data <= read_data_rx; 
        6: read_data <= read_data_tx;    
    endcase    
end 

assign req_data = data_req & periph_req[0];
assign req_rx = data_req & periph_req[5];
assign req_tx = data_req & periph_req[6];
 
 assign stall_i = ~stall & mem_req_o;  
    
     UART_RX_SB_CTRL uart_rx_sb_ctrl(
     .clk_i(sysclk),
     .rst_i(rst),
     .addr_i({8'd0, data_addr[23:0]}),
     .req_i(req_rx),
     .write_data_i(data_wdata),
     .write_enable_i(data_we),
     .read_data_o(read_data_rx),
     .rx_i(rx_i),
     .int_req(int_req_i)
    );
    
    
     UART_TX_SB_CTRL uart_tx_sb_ctrl(
     .clk_i(sysclk),
     .rst_i(rst),
     .addr_i({8'd0, data_addr[23:0]}),
     .req_i(req_tx),
     .write_data_i(data_wdata),
     .write_enable_i(data_we),
     .read_data_o(read_data_tx),
     .tx_o(tx_o)
    );
    
    
    riscv_core core
    (  
    .clk_i(sysclk),
    .rst_i(rst),
    .stall_i(stall_i),
    
    //.mem_rd_i(mem_rd),
    .instr_i(instr_i),
    .instr_addr_o(instr_addr_o),

    //.mem_size_o(),
    .data_rdata_i(read_data),
    .mcause_i(mcause),
    .INT_i(INT_),
    .data_addr_o(data_addr),
    .data_req_o(data_req),
    .data_we_o(data_we),
    .data_be_o(data_be),
    .data_wdata_o(data_wdata),
    .mie_o(mie),
    .INT_RST_o(INT_RST)
    );   
    
     miriscv_ram rm(
     .clk_i(sysclk),
     .rst_n_i(rst),
     .instr_rdata_o(instr_i),
     .instr_addr_i(instr_addr_o),
     .data_rdata_o(read_data_mem),
     .data_req_i(req_data),
     .data_we_i(data_we),
     .data_be_i(data_be),
     .data_addr_i({8'd0, data_addr_o[23:0]}),
     .data_wdata_i(data_wdata)
    );
    
      IC ic(
     .clk(sysclk),
     .mie_i(mie),
     .int_req_i(int_req_i),
     .INT_RST_i(INT_RST),
     .mcause_o(mcause),
     .INT_o(INT_),
     .int_fin_o()
    );
    
    //    instr_mem instr
//    (
//    .addr_i(instr_addr_o),
//    .read_data_o(instr_i)
//    );
    
//    data_mem data
//    (
//    .clk_i(clk_i),
//    .mem_req_i(mem_req_o),
//    .write_enable_i(mem_we_o),
//    .write_data_i(mem_wd_o),
//    .addr_i(data_addr_o),
//    .read_data_o(mem_rd)
//    );
    
//    always_ff @(posedge clk_i) 
//        begin
//        if (rst_i)
//            stall <= 0;
//        else
//            stall <= ~stall & mem_req_o;
//        end
endmodule