`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 09:14:58 AM
// Design Name: 
// Module Name: ALU
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


module ALU (
    input  [7:0] inA,           // Accumulator input
    input  [7:0] inB,           // Operand input
    input  [2:0] opcode,        // Operation selector
    output reg [7:0] out,       // ALU output
    output       is_zero        // Zero flag (out == 0)
);

    assign is_zero = (out == 8'b0);

    always @(*) begin
        case (opcode)
            3'b000: out = inA;              // HLT
            3'b001: out = inA;              // SKZ
            3'b010: out = inA + inB;        // ADD
            3'b011: out = inA & inB;        // AND
            3'b100: out = inA ^ inB;        // XOR
            3'b101: out = inB;              // LDA
            3'b110: out = inA;              // STO
            3'b111: out = inA;              // JMP
            default: out = 8'b0;
        endcase
    end

endmodule
