`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2025 07:27:18 PM
// Design Name: 
// Module Name: controller
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


module controller(
    input clk,
    input rst,
    input [2:0] opcode,
    input is_zero,
    output reg sel,
    output reg rd,
    output reg ld_ir,
    output reg halt,
    output reg ld_pc,
    output reg ld_ac,
    output reg inc_pc,
    output reg wr,
    output reg data_e
);
    localparam INST_ADDR    = 4'b000, 
               INST_FETCH   = 4'b001, 
               NST_LOAD     = 4'b010, 
               IDLE         = 4'b011,
               OP_ADDR      = 4'b100,
               OP_FETCH     = 4'b101,
               ALU_OP       = 4'b110, 
               STORE        = 4'b111;
               
    localparam HLT = 3'b000,
               SKZ = 3'b001,
               ADD = 3'b010,
               AND = 3'b011,
               XOR = 3'b100,
               LDA = 3'b101,
               STO = 3'b110,
               JMP = 3'b111;
    
    reg [2:0] state = INST_ADDR;    // Kh?i t?o state v? INST_ADDR
    reg [2:0] next_state = INST_ADDR;  // Kh?i t?o next_state v? INST_ADDR
    
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            state <= INST_ADDR;
        end
        else begin
            state <= next_state;
        end
    end
    
    always @ (*) begin
        case (state)
            INST_ADDR:  next_state = INST_FETCH;
            INST_FETCH: next_state = NST_LOAD;
            NST_LOAD:   next_state = IDLE;
            IDLE:       next_state = OP_ADDR;
            OP_ADDR:    next_state = OP_FETCH;
            OP_FETCH:   next_state = ALU_OP;
            ALU_OP:     next_state = STORE;
            STORE:      next_state = INST_ADDR;
            default:    next_state = INST_ADDR;
        endcase
    end
    
    always @ (*) begin
        sel     = 0;
        rd      = 0;
        ld_ir   = 0;
        halt    = 0;
        ld_pc   = 0;
        ld_ac   = 0;
        inc_pc  = 0;
        wr      = 0;
        data_e  = 0;
        case(state)
            INST_ADDR: begin
                sel = 1;
            end
            INST_FETCH: begin
                sel = 1;
                rd = 1;
            end
            NST_LOAD: begin
                sel = 1;
                rd = 1;
                ld_ir = 1;
            end
            IDLE: begin
                sel = 1;
                rd = 1;
                ld_ir = 1;
            end
            OP_ADDR: begin
                if (opcode == HLT) begin
                    halt = 1;
                end
                inc_pc = 1;
            end
            OP_FETCH: begin
                if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) begin
                    rd = 1;
                end
            end
            ALU_OP: begin
                if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) begin
                    rd = 1;
                end
                if (opcode == SKZ && is_zero) begin
                    inc_pc = 1;
                end
                if (opcode == JMP) begin
                    ld_pc = 1;
                end
                if (opcode == STO) begin
                    data_e = 1;
                end
            end
            STORE: begin
                if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) begin
                    rd = 1;
                    ld_ac = 1;
                end
                if (opcode == JMP) begin
                    ld_pc = 1;
                end
                if (opcode == STO) begin
                    wr = 1;
                    data_e = 1;
                end
            end         
        endcase
    end
endmodule
