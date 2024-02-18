`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2023 19:21:35
// Design Name: 
// Module Name: UART
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


module UART(
    input logic CLOCK,
    input logic RESET,
    input logic req_i,
    input logic we_i,
    
    input logic [31:0] DATA_i,

    //output logic [1:0] state_o,
    output logic OUT_o
    );

    //logic [1:0] DATA-info;
    logic [2:0] count;
    logic [31:0] mask;
    logic [7:0] DATA_BYTE;
    
    initial mask <= 32'hFFFFFFFF; 
    
    enum logic [1:0] {IDLE = 2'b00,
                      START = 2'b01,
                      DATA = 2'b10,
                      STOP = 2'b11}STATES;

always @(posedge CLOCK or posedge RESET) begin
    if (RESET) begin
        STATES <= IDLE;
        OUT_o <= 1;
        count <= 0;
    end
    else
        case (STATES)
            IDLE : begin
                if (req_i & we_i) begin
                    DATA_BYTE <= DATA_i[7:0];
                    $display(DATA_BYTE[7:0]);
                    STATES <= START;
                    OUT_o <= 0;
                end
            end
            START : begin
                STATES <= DATA;
            end
            DATA : begin
                if (count < 7) begin
                    OUT_o <= DATA_BYTE[count];
                    count <= count + 1;
                end else begin
                    count <= 0;
                    STATES <= STOP;
                end 
            end
            STOP : begin
                if (req_i & we_i) begin
                    STATES <= START;
                    OUT_o <= 0;
                end else 
                    STATES <= IDLE;
            end
        endcase
end

endmodule
