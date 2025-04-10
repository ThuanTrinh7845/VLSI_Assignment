`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench for cpu_top Module (cpu_top_tb_3)
// Description: This testbench verifies the functionality of the cpu_top module
// with the provided testcase for AND, XOR, and ADD operations.
// It observes the first 2000 clock cycles to track the execution flow,
// and checks the final state when the CPU halts.
// Clock period is set to 1ns (0.5ns high, 0.5ns low).
// Displays key signals including wr, data_e, and ld_ac from the controller.
//////////////////////////////////////////////////////////////////////////////////

module cpu_top_tb_2;

    // Inputs
    reg clk;
    reg rst;

    // Outputs
    wire halt;

    // Instantiate the Unit Under Test (UUT)
    cpu_top uut (
        .clk(clk),
        .rst(rst),
        .halt(halt)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #0.5 clk = ~clk;  // Chu k? clock 1ns (0.5ns high, 0.5ns low)
    end

    // Test stimulus
    initial begin
        // Kh?i t?o giá tr? ban ð?u
        rst = 1;
        #1;  // Ð?i 1 chu k? clock ð? reset
        rst = 0;

        // Kh?i t?o b? nh? sau khi reset
        for (integer i = 0; i < 32; i = i + 1) begin
            uut.mem_inst.mem[i] = 8'h00;
        end

        // Kh?i t?o n?i dung b? nh? theo ðo?n m? assembly
        uut.mem_inst.mem[8'h00] = 8'hBB; // 10111011: LDA 0x1B (DATA_2)
        uut.mem_inst.mem[8'h01] = 8'h7C; // 01111100: AND 0x1C (DATA_3)
        uut.mem_inst.mem[8'h02] = 8'h9B; // 10011011: XOR 0x1B (DATA_2)
        uut.mem_inst.mem[8'h03] = 8'h20; // 00100000: SKZ
        uut.mem_inst.mem[8'h04] = 8'h00; // 00000000: HLT
        uut.mem_inst.mem[8'h05] = 8'h5A; // 01011010: ADD 0x1A (DATA_1)
        uut.mem_inst.mem[8'h06] = 8'h20; // 00100000: SKZ
        uut.mem_inst.mem[8'h07] = 8'hE9; // 11101001: JMP 0x09 (ADD_OK)
        uut.mem_inst.mem[8'h08] = 8'h00; // 00000000: HLT
        uut.mem_inst.mem[8'h09] = 8'h9C; // 10011100: XOR 0x1C (DATA_3)
        uut.mem_inst.mem[8'h0A] = 8'h5A; // 01011010: ADD 0x1A (DATA_1)
        uut.mem_inst.mem[8'h0B] = 8'hDD; // 11011101: STO 0x1D (TEMP)
        uut.mem_inst.mem[8'h0C] = 8'hBA; // 10111010: LDA 0x1A (DATA_1)
        uut.mem_inst.mem[8'h0D] = 8'h5D; // 01011101: ADD 0x1D (TEMP)
        uut.mem_inst.mem[8'h0E] = 8'h20; // 00100000: SKZ
        uut.mem_inst.mem[8'h0F] = 8'h00; // 00000000: HLT
        uut.mem_inst.mem[8'h10] = 8'h00; // 00000000: HLT
        uut.mem_inst.mem[8'h11] = 8'hE0; // 11100000: JMP 0x00 (BEGIN)
        // Kh?i t?o d? li?u
        uut.mem_inst.mem[8'h1A] = 8'h01; // DATA_1 = 0x01
        uut.mem_inst.mem[8'h1B] = 8'hAA; // DATA_2 = 0xAA
        uut.mem_inst.mem[8'h1C] = 8'hFF; // DATA_3 = 0xFF
        uut.mem_inst.mem[8'h1D] = 8'h00; // TEMP = 0x00

        // Quan sát 2000 chu k? clock ð?u tiên
        $display("\n=== Observing First 2000 Clock Cycles to Track Execution Flow ===\n");
        repeat (500) begin
            @(posedge clk);
            $display("Cycle %0d at time %0t:", $time, $time);
            $display("  PC = %h", uut.pc_inst.pc_out);
            $display("  Memory Address = %h", uut.mem_addr);
            $display("  Memory Data Out = %h", uut.mem_data_out);
            $display("  IR Instruction = %h", uut.ir_inst.instruction);
            $display("  IR Opcode = %b", uut.ir_inst.opcode);
            $display("  IR Operand = %h", uut.ir_inst.operand);
            $display("  Controller State = %b", uut.ctrl_inst.state);
            $display("  Controller Signals: sel=%b, rd=%b, ld_ir=%b, inc_pc=%b, ld_pc=%b, ld_ac=%b, wr=%b, data_e=%b", 
                     uut.ctrl_inst.sel, uut.ctrl_inst.rd, uut.ctrl_inst.ld_ir, 
                     uut.ctrl_inst.inc_pc, uut.ctrl_inst.ld_pc, uut.ctrl_inst.ld_ac,
                     uut.ctrl_inst.wr, uut.ctrl_inst.data_e);
            $display("  Accumulator = %h", uut.acc_inst.data_out);
            $display("  Memory[DATA_1] (addr 0x1A) = %h", uut.mem_inst.mem[8'h1A]);
            $display("  Memory[DATA_2] (addr 0x1B) = %h", uut.mem_inst.mem[8'h1B]);
            $display("  Memory[DATA_3] (addr 0x1C) = %h", uut.mem_inst.mem[8'h1C]);
            $display("  Memory[TEMP] (addr 0x1D) = %h", uut.mem_inst.mem[8'h1D]);
            $display("  Halt = %b\n", halt);
        end

        // Ch?y CPU ð?n khi d?ng
        $display("\n=== Running CPU Until Halt ===\n");
        wait(halt == 1);
        #10;
        $display("CPU halted at time %0t", $time);
        $display("PC = %h", uut.pc_inst.pc_out);
        $display("Accumulator = %h", uut.acc_inst.data_out);
        $display("Memory[DATA_1] (addr 0x1A) = %h", uut.mem_inst.mem[8'h1A]);
        $display("Memory[DATA_2] (addr 0x1B) = %h", uut.mem_inst.mem[8'h1B]);
        $display("Memory[DATA_3] (addr 0x1C) = %h", uut.mem_inst.mem[8'h1C]);
        $display("Memory[TEMP] (addr 0x1D) = %h", uut.mem_inst.mem[8'h1D]);

        // Ki?m tra k?t qu? cu?i cùng
        $display("\n=== Final Check ===");
        if (uut.pc_inst.pc_out == 5'h10 && 
            uut.acc_inst.data_out == 8'h00 && 
            uut.mem_inst.mem[8'h1D] == 8'hFF) begin
            $display("Test Passed: All expected values match!");
            $display("PC = 0x10, Accumulator = 0x00, Memory[TEMP] = 0xFF");
        end else begin
            $display("Test Failed!");
            if (uut.pc_inst.pc_out != 5'h10)
                $display("PC expected 0x10, got %h", uut.pc_inst.pc_out);
            if (uut.acc_inst.data_out != 8'h00)
                $display("Accumulator expected 0x00, got %h", uut.acc_inst.data_out);
            if (uut.mem_inst.mem[8'h1D] != 8'hFF)
                $display("Memory[TEMP] expected 0xFF, got %h", uut.mem_inst.mem[8'h1D]);
        end

        // K?t thúc mô ph?ng
        #40;
        $display("Simulation completed!");
        $stop;
    end

    // Monitor các tín hi?u quan tr?ng
    initial begin
        $monitor("Time=%0t | rst=%b | PC=%h | opcode=%b | operand=%h | acc_out=%h | alu_out=%h | is_zero=%b | halt=%b",
                 $time, rst, uut.pc_inst.pc_out, uut.ir_inst.opcode, uut.ir_inst.operand,
                 uut.acc_inst.data_out, uut.alu_inst.out, uut.is_zero, halt);
    end

endmodule