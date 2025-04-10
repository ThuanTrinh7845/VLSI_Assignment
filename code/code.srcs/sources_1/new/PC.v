`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 09:07:18 AM
// Design Name: 
// Module Name: PC
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


module PC (
    input wire clk,          // Xung clock
    input wire rst,          // Tín hi?u reset m?c cao
    input wire ld_pc,        // Tín hi?u load PC
    input wire inc_pc,       // Tín hi?u tãng PC
    input wire halt, 
    input wire [4:0] pc_in,  // Giá tr? n?p vào PC (5 bit)
    output reg [4:0] pc_out  // Giá tr? hi?n t?i c?a PC (5 bit)
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out <= 5'b00000;  // Reset v? 0 khi rst = 1
        end
        else if (halt) begin
            pc_out <= pc_out;
        end
        else if (ld_pc) begin
            pc_out <= pc_in;     // N?p giá tr? t? pc_in khi ld_pc = 1
        end
        else if (inc_pc) begin
            pc_out <= pc_out + 1; // Tãng PC lên 1 khi inc_pc = 1
        end
    end

endmodule