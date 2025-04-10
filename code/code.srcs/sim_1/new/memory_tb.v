`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench for Memory Module (Vivado)
// Description: This testbench verifies the functionality of the memory module,
// including reset, read, and write operations, with memory initialized as specified.
//////////////////////////////////////////////////////////////////////////////////

module memory_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [4:0] addr;
    reg wr;
    reg [7:0] data_in;
    reg rd;

    // Outputs
    wire [7:0] data_out;

    // Instantiate the Unit Under Test (UUT)
    memory uut (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .wr(wr),
        .data_in(data_in),
        .data_out(data_out),
        .rd(rd)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Chu k? clock 10ns (5ns high, 5ns low)
    end

    // Kh?i t?o b? nh? ban ð?u
    initial begin
        // Ð?t t?t c? ô nh? v? 0 trý?c
        for (integer i = 0; i < 32; i = i + 1) begin
            uut.mem[i] = 8'h00;
        end

        // Kh?i t?o n?i dung b? nh? theo ðo?n m? assembly
        uut.mem[8'h00] = 8'b111_11110; // FE (JMP TST_JMP)
        uut.mem[8'h01] = 8'b000_00000; // 00 (HLT)
        uut.mem[8'h02] = 8'b000_00000; // 00 (HLT)
        uut.mem[8'h03] = 8'b101_11010; // BA (LDA DATA_1)
        uut.mem[8'h04] = 8'b001_00000; // 20 (SKZ)
        uut.mem[8'h05] = 8'b000_00000; // 00 (HLT)
        uut.mem[8'h06] = 8'b101_11011; // BB (LDA DATA_2)
        uut.mem[8'h07] = 8'b001_00000; // 20 (SKZ)
        uut.mem[8'h08] = 8'b111_01010; // EA (JMP SKZ_OK)
        uut.mem[8'h09] = 8'b000_00000; // 00 (HLT)
        uut.mem[8'h0A] = 8'b110_11100; // DC (STO TEMP)
        uut.mem[8'h0B] = 8'b101_11010; // BA (LDA DATA_1)
        uut.mem[8'h0C] = 8'b110_11100; // DC (STO TEMP)
        uut.mem[8'h0D] = 8'b101_11100; // BC (LDA TEMP)
        uut.mem[8'h0E] = 8'b001_00000; // 20 (SKZ)
        uut.mem[8'h0F] = 8'b000_00000; // 00 (HLT)
        uut.mem[8'h10] = 8'b100_11011; // 9B (XOR DATA_2)
        uut.mem[8'h11] = 8'b001_00000; // 20 (SKZ)
        uut.mem[8'h12] = 8'b111_10100; // F4 (JMP XOR_OK)
        uut.mem[8'h13] = 8'b000_00000; // 00 (HLT)
        uut.mem[8'h14] = 8'b100_11011; // 9B (XOR DATA_2)
        uut.mem[8'h15] = 8'b001_00000; // 20 (SKZ)
        uut.mem[8'h16] = 8'b000_00000; // 00 (HLT)
        uut.mem[8'h17] = 8'b000_00000; // 00 (HLT)
        uut.mem[8'h18] = 8'b111_00000; // E0 (JMP BEGIN)
        // 19: 00 (m?c ð?nh)
        uut.mem[8'h1A] = 8'b00000000; // 00 (DATA_1)
        uut.mem[8'h1B] = 8'b11111111; // FF (DATA_2)
        uut.mem[8'h1C] = 8'b10101010; // AA (TEMP)
        // 1D: 00 (m?c ð?nh)
        uut.mem[8'h1E] = 8'b111_00011; // E3 (JMP JMP_OK)
        uut.mem[8'h1F] = 8'b000_00000; // 00 (HLT)
    end

    // Test stimulus
    initial begin
        // Kh?i t?o giá tr? ban ð?u
        rst = 0;
        addr = 5'b0;
        wr = 0;
        data_in = 8'h00;
        rd = 0;

        // Test Case 1: Ki?m tra n?i dung b? nh? ban ð?u
        $display("Test Case 1: Check initial memory content");
        #10;
        rd = 1;
        addr = 5'h00;  // Ð?c ð?a ch? 0x00 (FE)
        #10;
        if (data_out !== 8'hFE) begin
            $display("Test Case 1 Failed at %0t: Expected data_out = FE at addr 0x00, got %h", $time, data_out);
        end else begin
            $display("Test Case 1 Passed at %0t: data_out = FE at addr 0x00", $time);
        end

        addr = 5'h1A;  // Ð?c ð?a ch? 0x1A (DATA_1: 00)
        #10;
        if (data_out !== 8'h00) begin
            $display("Test Case 1 Failed at %0t: Expected data_out = 00 at addr 0x1A, got %h", $time, data_out);
        end else begin
            $display("Test Case 1 Passed at %0t: data_out = 00 at addr 0x1A", $time);
        end

        addr = 5'h1B;  // Ð?c ð?a ch? 0x1B (DATA_2: FF)
        #10;
        if (data_out !== 8'hFF) begin
            $display("Test Case 1 Failed at %0t: Expected data_out = FF at addr 0x1B, got %h", $time, data_out);
        end else begin
            $display("Test Case 1 Passed at %0t: data_out = FF at addr 0x1B", $time);
        end

        addr = 5'h1C;  // Ð?c ð?a ch? 0x1C (TEMP: AA)
        #10;
        if (data_out !== 8'hAA) begin
            $display("Test Case 1 Failed at %0t: Expected data_out = AA at addr 0x1C, got %h", $time, data_out);
        end else begin
            $display("Test Case 1 Passed at %0t: data_out = AA at addr 0x1C", $time);
        end

        rd = 0;
        #10;

        // Test Case 2: Reset b? nh?
        $display("Test Case 2: Reset memory");
        rst = 1;
        #10;
        rst = 0;
        rd = 1;
        addr = 5'h1C;  // Ð?c ð?a ch? 0x1C (sau reset, ph?i là 00)
        #10;
        if (data_out !== 8'h00) begin
            $display("Test Case 2 Failed at %0t: Expected data_out = 00 at addr 0x1C after reset, got %h", $time, data_out);
        end else begin
            $display("Test Case 2 Passed at %0t: data_out = 00 at addr 0x1C after reset", $time);
        end

        rd = 0;
        #10;

        // Test Case 3: Ghi và ð?c d? li?u
        $display("Test Case 3: Write and read data");
        addr = 5'h1C;  // Ghi vào ð?a ch? TEMP (0x1C)
        data_in = 8'h55;  // Ghi giá tr? 0x55
        wr = 1;
        #10;
        wr = 0;
        #10;
        rd = 1;
        #10;
        if (data_out !== 8'h55) begin
            $display("Test Case 3 Failed at %0t: Expected data_out = 55 at addr 0x1C after write, got %h", $time, data_out);
        end else begin
            $display("Test Case 3 Passed at %0t: data_out = 55 at addr 0x1C after write", $time);
        end

        // Test Case 4: Ki?m tra data_out khi rd = 0
        $display("Test Case 4: Check data_out when rd = 0");
        rd = 0;
        #10;
        if (data_out !== 8'bz) begin
            $display("Test Case 4 Failed at %0t: Expected data_out = z when rd = 0, got %h", $time, data_out);
        end else begin
            $display("Test Case 4 Passed at %0t: data_out = z when rd = 0", $time);
        end

        // K?t thúc mô ph?ng
        $display("Simulation completed!");
        $stop;
    end

    // Monitor ð? quan sát các tín hi?u
    initial begin
        $monitor("Time=%0t | rst=%b | addr=%h | wr=%b | rd=%b | data_in=%h | data_out=%h",
                 $time, rst, addr, wr, rd, data_in, data_out);
    end

endmodule