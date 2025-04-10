`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 02:32:42 PM
// Design Name: 
// Module Name: cpu_top
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


module cpu_top(
    input wire clk,
    input wire rst,
    output wire halt
);

    // Internal wires declaration
    wire [2:0] opcode;
    wire is_zero;
    wire sel;
    wire rd;
    wire ld_ir;
    wire ld_pc;
    wire ld_ac;
    wire inc_pc;
    wire wr;
    wire data_e;
    
    wire [4:0] pc_out;
    wire [4:0] mem_addr;
    wire [7:0] instruction;
    wire [7:0] mem_data_out;
    wire [7:0] alu_out;
    wire [7:0] accumulator_data;
    wire [4:0] operand;
    
    // Module instantiations
    
    // Program Counter
    PC pc_inst(
        .clk(clk),
        .rst(rst),
        .inc_pc(inc_pc),
        .ld_pc(ld_pc),
        .halt(halt),
        .pc_in(operand),  // For JMP instruction
        .pc_out(pc_out)
    );
    
    // Address Mux
    address_mux addr_mux_inst(
        .sel(sel),
        .addr_in0(operand),  // Operand from IR
        .addr_in1(pc_out),   // PC value
        .addr_out(mem_addr)
    );
    
    // Memory
    memory mem_inst(
        .clk(clk),
        .rst(rst),
        .addr(mem_addr),
        .wr(wr),
        .data_in(accumulator_data),
        .data_out(mem_data_out),
        .rd(rd)
    );
    
    // Instruction Register
    IR ir_inst(
        .clk(clk),
        .rst(rst),
        .ld_ir(ld_ir),
        .instruction(mem_data_out),
        .opcode(opcode),
        .operand(operand)
    );
    
    // Accumulator
    accumulator acc_inst(
        .clk(clk),
        .rst(rst),
        .load(ld_ac),
        .data_in(alu_out),
        .data_out(accumulator_data)
    );
    
    // ALU
    ALU alu_inst(
        .inA(accumulator_data),
        .inB(mem_data_out),
        .opcode(opcode),
        .out(alu_out),
        .is_zero(is_zero)
    );
    
    // Controller
    controller ctrl_inst(
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .is_zero(is_zero),
        .sel(sel),
        .rd(rd),
        .ld_ir(ld_ir),
        .halt(halt),
        .ld_pc(ld_pc),
        .ld_ac(ld_ac),
        .inc_pc(inc_pc),
        .wr(wr),
        .data_e(data_e)
    );

endmodule
