`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench for cpu_top Module (cpu_top_tb_3)
// Description: This testbench verifies the functionality of the cpu_top module
// with the provided Fibonacci sequence assembly code.
// It observes the first 2000 clock cycles to track the execution flow,
// and checks the final state when the CPU halts.
// Clock period is set to 1ns (0.5ns high, 0.5ns low).
// Displays key signals including wr, data_e, and ld_ac from the controller.
//////////////////////////////////////////////////////////////////////////////////

module cpu_top_tb_3;

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
        // Kh?i t?o gi� tr? ban �?u
        rst = 1;
        #1;  // �?i 1 chu k? clock �? reset
        rst = 0;

        // Kh?i t?o b? nh? sau khi reset
        for (integer i = 0; i < 32; i = i + 1) begin
            uut.mem_inst.mem[i] = 8'h00;
        end

        // Kh?i t?o n?i dung b? nh? theo �o?n m? assembly (Fibonacci)
        uut.mem_inst.mem[8'h00] = 8'hE3; // 11100011: JMP 0x03 (LOOP)
        uut.mem_inst.mem[8'h03] = 8'hBB; // 10111011: LDA 0x1B (FN2)
        uut.mem_inst.mem[8'h04] = 8'hDC; // 11011100: STO 0x1C (TEMP)
        uut.mem_inst.mem[8'h05] = 8'h5A; // 01011010: ADD 0x1A (FN1)
        uut.mem_inst.mem[8'h06] = 8'hDB; // 11011011: STO 0x1B (FN2)
        uut.mem_inst.mem[8'h07] = 8'hBC; // 10111100: LDA 0x1C (TEMP)
        uut.mem_inst.mem[8'h08] = 8'hDA; // 11011010: STO 0x1A (FN1)
        uut.mem_inst.mem[8'h09] = 8'h9D; // 10011101: XOR 0x1D (LIMIT)
        uut.mem_inst.mem[8'h0A] = 8'h20; // 00100000: SKZ
        uut.mem_inst.mem[8'h0B] = 8'hE3; // 11100011: JMP 0x03 (LOOP)
        uut.mem_inst.mem[8'h0C] = 8'h00; // 00000000: HLT
        uut.mem_inst.mem[8'h0D] = 8'hBF; // 10111111: LDA 0x1F (ONE)
        uut.mem_inst.mem[8'h0E] = 8'hDA; // 11011010: STO 0x1A (FN1)
        uut.mem_inst.mem[8'h0F] = 8'hBE; // 10111110: LDA 0x1E (ZERO)
        uut.mem_inst.mem[8'h10] = 8'hDB; // 11011011: STO 0x1B (FN2)
        uut.mem_inst.mem[8'h11] = 8'hE3; // 11100011: JMP 0x03 (LOOP)

        // Kh?i t?o d? li?u
        uut.mem_inst.mem[8'h1A] = 8'h01; // FN1 = 1
        uut.mem_inst.mem[8'h1B] = 8'h00; // FN2 = 0
        uut.mem_inst.mem[8'h1C] = 8'h00; // TEMP = 0
        uut.mem_inst.mem[8'h1D] = 8'h90; // LIMIT = 144 (decimal) = 0x90
        uut.mem_inst.mem[8'h1E] = 8'h00; // ZERO = 0
        uut.mem_inst.mem[8'h1F] = 8'h01; // ONE = 1

        // Quan s�t 2000 chu k? clock �?u ti�n
        $display("\n=== Observing First 2000 Clock Cycles to Track Fibonacci Execution ===\n");
        repeat (1500) begin
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
            $display("  Memory[FN1] (addr 0x1A) = %h", uut.mem_inst.mem[8'h1A]);
            $display("  Memory[FN2] (addr 0x1B) = %h", uut.mem_inst.mem[8'h1B]);
            $display("  Memory[TEMP] (addr 0x1C) = %h", uut.mem_inst.mem[8'h1C]);
            $display("  Halt = %b\n", halt);
        end

        // Ch?y CPU �?n khi d?ng
        $display("\n=== Running CPU Until Halt ===\n");
        wait(halt == 1);
        #10;
        $display("CPU halted at time %0t", $time);
        $display("PC = %h", uut.pc_inst.pc_out);
        $display("Accumulator = %h", uut.acc_inst.data_out);
        $display("Memory[FN1] (addr 0x1A) = %h", uut.mem_inst.mem[8'h1A]);
        $display("Memory[FN2] (addr 0x1B) = %h", uut.mem_inst.mem[8'h1B]);
        $display("Memory[TEMP] (addr 0x1C) = %h", uut.mem_inst.mem[8'h1C]);

        // Ki?m tra k?t qu? cu?i c�ng
        $display("\n=== Final Check ===");
        if (uut.pc_inst.pc_out == 5'h0C && 
            uut.mem_inst.mem[8'h1A] == 8'h90 && 
            uut.mem_inst.mem[8'h1B] == 8'hE9) begin
            $display("Test Passed: Fibonacci sequence computed correctly!");
            $display("PC = 0x0C, FN1 = 0x90 (144), FN2 = 0xE9 (233)");
        end else begin
            $display("Test Failed!");
            if (uut.pc_inst.pc_out != 5'h0C)
                $display("PC expected 0x0C, got %h", uut.pc_inst.pc_out);
            if (uut.mem_inst.mem[8'h1A] != 8'h90)
                $display("FN1 expected 0x90, got %h", uut.mem_inst.mem[8'h1A]);
            if (uut.mem_inst.mem[8'h1B] != 8'hE9)
                $display("FN2 expected 0xE9, got %h", uut.mem_inst.mem[8'h1B]);
        end

        // K?t th�c m� ph?ng
        #40;
        $display("Simulation completed!");
        $stop;
    end

    // Monitor c�c t�n hi?u quan tr?ng
    initial begin
        $monitor("Time=%0t | rst=%b | PC=%h | opcode=%b | operand=%h | acc_out=%h | alu_out=%h | is_zero=%b | halt=%b",
                 $time, rst, uut.pc_inst.pc_out, uut.ir_inst.opcode, uut.ir_inst.operand,
                 uut.acc_inst.data_out, uut.alu_inst.out, uut.is_zero, halt);
    end

endmodule