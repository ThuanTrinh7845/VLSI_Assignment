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
    input wire rst,          // T�n hi?u reset m?c cao
    input wire ld_pc,        // T�n hi?u load PC
    input wire inc_pc,       // T�n hi?u t�ng PC
    input wire halt, 
    input wire [4:0] pc_in,  // Gi� tr? n?p v�o PC (5 bit)
    output reg [4:0] pc_out  // Gi� tr? hi?n t?i c?a PC (5 bit)
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out <= 5'b00000;  // Reset v? 0 khi rst = 1
        end
        else if (halt) begin
            pc_out <= pc_out;
        end
        else if (ld_pc) begin
            pc_out <= pc_in;     // N?p gi� tr? t? pc_in khi ld_pc = 1
        end
        else if (inc_pc) begin
            pc_out <= pc_out + 1; // T�ng PC l�n 1 khi inc_pc = 1
        end
    end

endmodule