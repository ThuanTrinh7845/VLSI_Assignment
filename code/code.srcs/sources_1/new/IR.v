`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 09:02:42 AM
// Design Name: 
// Module Name: IR
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


`timescale 1ns / 1ps

module IR(
    input wire clk,
    input wire rst,
    input wire ld_ir,                  // Load instruction register
    input wire [7:0] instruction,      // Input from memory

    output reg [2:0] opcode,           // Output to controller & ALU
    output reg [4:0] operand           // Output to memory & PC (via MUX)
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            opcode <= 3'b000;
            operand <= 5'b00000;
        end else if (ld_ir) begin
            opcode <= instruction[7:5];   // MSBs for opcode
            operand <= instruction[4:0];  // LSBs for operand (e.g., memory address)
        end
    end

endmodule
