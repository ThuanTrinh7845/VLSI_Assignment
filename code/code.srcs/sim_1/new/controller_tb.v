`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench for Controller Module - JMP Opcode Case (Vivado)
// Description: This testbench verifies the behavior of the controller module
// for the JMP opcode (111), checking ld_pc in ALU_OP and STORE.
//////////////////////////////////////////////////////////////////////////////////

module controller_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [2:0] opcode;
    reg is_zero;

    // Outputs
    wire sel;
    wire rd;
    wire ld_ir;
    wire halt;
    wire ld_pc;
    wire ld_ac;
    wire inc_pc;
    wire wr;
    wire data_e;

    // Instantiate the Unit Under Test (UUT)
    controller uut (
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

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Chu k? clock 10ns (5ns high, 5ns low)
    end

    // Test stimulus
    initial begin
        // Kh?i t?o giá tr? ban ð?u
        rst = 1;
        opcode = 3'b111;  // JMP
        is_zero = 0;

        // Reset
        #10;
        rst = 0;  // B? reset sau 10ns

        // Test Case: JMP opcode (111)
        $display("Test Case: JMP opcode (111)");
        opcode = 3'b111;  // JMP
        is_zero = 0;
        #80;  // Ch? ði qua t?t c? các tr?ng thái

        // K?t thúc mô ph?ng
        $display("Simulation completed!");
        $stop;
    end

    // Ki?m tra tín hi?u ld_pc trong ALU_OP và STORE
    initial begin
        // ALU_OP (60ns - 70ns)
        #60;
        if (ld_pc !== 1'b1) begin
            $display("Test Failed at %0t: ld_pc should be 1 in ALU_OP state for JMP!", $time);
        end else begin
            $display("Test Passed at %0t: ld_pc is correctly set to 1 in ALU_OP state for JMP.", $time);
        end

        // STORE (70ns - 80ns)
        #10;
        if (ld_pc !== 1'b1) begin
            $display("Test Failed at %0t: ld_pc should be 1 in STORE state for JMP!", $time);
        end else begin
            $display("Test Passed at %0t: ld_pc is correctly set to 1 in STORE state for JMP.", $time);
        end
    end

    // Monitor ð? quan sát các tín hi?u
    initial begin
        $monitor("Time=%0t | rst=%b | state=%b | opcode=%b | is_zero=%b | sel=%b | rd=%b | ld_ir=%b | halt=%b | ld_pc=%b | ld_ac=%b | inc_pc=%b | wr=%b | data_e=%b",
                 $time, rst, uut.state, opcode, is_zero, sel, rd, ld_ir, halt, ld_pc, ld_ac, inc_pc, wr, data_e);
    end

endmodule