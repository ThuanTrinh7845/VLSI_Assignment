`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench for cpu_top Module
// Description: This testbench verifies the functionality of the cpu_top module,
// observing the first 200 clock cycles to track the execution flow,
// and checking the final state when the CPU halts.
// Clock period reduced to 2ns (1ns high, 1ns low).
// Added wr and data_e signals to Controller Signals display.
//////////////////////////////////////////////////////////////////////////////////

module cpu_top_tb;

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
        forever #1 clk = ~clk;  // Chu k? clock 2ns (1ns high, 1ns low)
    end

    // Test stimulus
    initial begin
        // Kh?i t?o giá tr? ban ð?u
        rst = 1;
        #2;  // Ð?i 1 chu k? clock ð? reset
        rst = 0;

        // Kh?i t?o b? nh? sau khi reset
        for (integer i = 0; i < 32; i = i + 1) begin
            uut.mem_inst.mem[i] = 8'h00;
        end
        uut.mem_inst.mem[8'h00] = 8'hFE; // 111_11110: JMP 0x1E (TST_JMP)
        uut.mem_inst.mem[8'h01] = 8'h00; // 000_00000: HLT
        uut.mem_inst.mem[8'h02] = 8'h00; // 000_00000: HLT
        uut.mem_inst.mem[8'h03] = 8'hBA; // 101_11010: LDA 0x1A (DATA_1)
        uut.mem_inst.mem[8'h04] = 8'h20; // 001_00000: SKZ
        uut.mem_inst.mem[8'h05] = 8'h00; // 000_00000: HLT
        uut.mem_inst.mem[8'h06] = 8'hBB; // 101_11011: LDA 0x1B (DATA_2)
        uut.mem_inst.mem[8'h07] = 8'h20; // 001_00000: SKZ
        uut.mem_inst.mem[8'h08] = 8'hEA; // 111_01010: JMP 0x0A (SKZ_OK)
        uut.mem_inst.mem[8'h09] = 8'h00; // 000_00000: HLT
        uut.mem_inst.mem[8'h0A] = 8'hDC; // 110_11100: STO 0x1C (TEMP)
        uut.mem_inst.mem[8'h0B] = 8'hBA; // 101_11010: LDA 0x1A (DATA_1)
        uut.mem_inst.mem[8'h0C] = 8'hDC; // 110_11100: STO 0x1C (TEMP)
        uut.mem_inst.mem[8'h0D] = 8'hBC; // 101_11100: LDA 0x1C (TEMP)
        uut.mem_inst.mem[8'h0E] = 8'h20; // 001_00000: SKZ
        uut.mem_inst.mem[8'h0F] = 8'h00; // 000_00000: HLT
        uut.mem_inst.mem[8'h10] = 8'h9B; // 100_11011: XOR 0x1B (DATA_2)
        uut.mem_inst.mem[8'h11] = 8'h20; // 001_00000: SKZ
        uut.mem_inst.mem[8'h12] = 8'hF4; // 111_10100: JMP 0x14 (XOR_OK)
        uut.mem_inst.mem[8'h13] = 8'h00; // 000_00000: HLT
        uut.mem_inst.mem[8'h14] = 8'h9B; // 100_11011: XOR 0x1B (DATA_2)
        uut.mem_inst.mem[8'h15] = 8'h20; // 001_00000: SKZ
        uut.mem_inst.mem[8'h16] = 8'h00; // 000_00000: HLT
        uut.mem_inst.mem[8'h17] = 8'h00; // 000_00000: HLT
        uut.mem_inst.mem[8'h18] = 8'hE0; // 111_00000: JMP 0x00 (BEGIN)
        uut.mem_inst.mem[8'h1A] = 8'h00; // DATA_1 = 0x00
        uut.mem_inst.mem[8'h1B] = 8'hFF; // DATA_2 = 0xFF
        uut.mem_inst.mem[8'h1C] = 8'hAA; // TEMP = 0xAA
        uut.mem_inst.mem[8'h1E] = 8'hE3; // 111_00011: JMP 0x03 (JMP_OK)
        uut.mem_inst.mem[8'h1F] = 8'h00; // 000_00000: HLT

        // Quan sát 200 chu k? clock ð?u tiên
        $display("\n=== Observing First 200 Clock Cycles to Track Execution Flow ===\n");
        repeat (200) begin
            @(posedge clk);
            $display("Cycle %0d at time %0t:", $time/2, $time);
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
            $display("  Memory[TEMP] (addr 0x1C) = %h", uut.mem_inst.mem[8'h1C]);
            $display("  Halt = %b\n", halt);
        end

        // Ch?y CPU ð?n khi d?ng
        $display("\n=== Running CPU Until Halt ===\n");
        wait(halt == 1);
        #10;
        $display("CPU halted at time %0t", $time);
        $display("PC = %h", uut.pc_inst.pc_out);
        $display("Accumulator = %h", uut.acc_inst.data_out);
        $display("Memory[TEMP] (addr 0x1C) = %h", uut.mem_inst.mem[8'h1C]);

        // Ki?m tra k?t qu? cu?i cùng
        $display("\n=== Final Check ===");
        if (uut.pc_inst.pc_out == 5'h17 && 
            uut.acc_inst.data_out == 8'h00 && 
            uut.mem_inst.mem[8'h1C] == 8'h00) begin
            $display("Test Passed: All expected values match!");
            $display("PC = 0x17, Accumulator = 0x00, Memory[TEMP] = 0x00");
        end else begin
            $display("Test Failed!");
            if (uut.pc_inst.pc_out != 5'h17)
                $display("PC expected 0x17, got %h", uut.pc_inst.pc_out);
            if (uut.acc_inst.data_out != 8'h00)
                $display("Accumulator expected 0x00, got %h", uut.acc_inst.data_out);
            if (uut.mem_inst.mem[8'h1C] != 8'h00)
                $display("Memory[TEMP] expected 0x00, got %h", uut.mem_inst.mem[8'h1C]);
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