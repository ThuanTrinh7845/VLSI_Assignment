`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2025 08:00:00 PM
// Design Name: 
// Module Name: accumulator
// Project Name: RISC CPU
// Target Devices: 
// Tool Versions: 
// Description: Accumulator module for RISC CPU, implemented as a register.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module accumulator (
    input wire clk,          
    input wire rst,         
    input wire load,         
    input wire [7:0] data_in, 
    output reg [7:0] data_out 
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0;
        end
        else if (load) begin
            data_out <= data_in; 
        end
    end

endmodule