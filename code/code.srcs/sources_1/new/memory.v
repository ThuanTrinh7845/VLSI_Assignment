`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 08:33:26 AM
// Design Name: 
// Module Name: memory
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


module memory (
    input wire clk,
    input wire rst,
    input wire [4:0] addr,
    input wire wr,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    input wire rd
);
    reg [7:0] mem [0:31];  // B? nh? 32 ô, m?i ô 8 bit
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset b? nh? (tùy ch?n)
            for (i = 0; i < 32; i = i + 1) begin
                mem[i] <= 8'h00;
            end
        end
        else if (wr) begin
            mem[addr] <= data_in;  // Ghi d? li?u vào b? nh?
        end
    end

    always @(*) begin
        if (rd)
            data_out = mem[addr];  // Ð?c d? li?u ra
        else
            data_out = 8'bz;       // High impedance n?u không ð?c
    end
endmodule
