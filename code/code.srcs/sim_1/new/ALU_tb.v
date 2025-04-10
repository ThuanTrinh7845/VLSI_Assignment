`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 09:20:40 AM
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb;

    // Inputs
    reg [7:0] inA;
    reg [7:0] inB;
    reg [2:0] opcode;

    // Outputs
    wire [7:0] out;
    wire is_zero;

    // Instantiate the Unit Under Test (UUT)
    ALU uut (
        .inA(inA),
        .inB(inB),
        .opcode(opcode),
        .out(out),
        .is_zero(is_zero)
    );

    // Test stimulus
    initial begin
        // Kh?i t?o giá tr? ban ð?u
        inA = 8'h00;
        inB = 8'h00;
        opcode = 3'b000;

        // Test Case 1: HLT (opcode 000)
        $display("Test Case 1: HLT (opcode 000)");
        opcode = 3'b000;
        inA = 8'h42;  // Accumulator = 0x42
        inB = 8'hFF;  // Không dùng
        #10;
        if (out !== 8'h42) begin
            $display("Test Case 1 Failed at %0t: Expected out = 42, got %h", $time, out);
        end else begin
            $display("Test Case 1 Passed at %0t: out = 42", $time);
        end
        if (is_zero !== 1'b0) begin
            $display("Test Case 1 Failed at %0t: Expected is_zero = 0, got %b", $time, is_zero);
        end else begin
            $display("Test Case 1 Passed at %0t: is_zero = 0", $time);
        end

        // Test Case 2: SKZ (opcode 001)
        $display("Test Case 2: SKZ (opcode 001)");
        opcode = 3'b001;
        inA = 8'h00;  // Accumulator = 0x00
        inB = 8'hFF;  // Không dùng
        #10;
        if (out !== 8'h00) begin
            $display("Test Case 2 Failed at %0t: Expected out = 00, got %h", $time, out);
        end else begin
            $display("Test Case 2 Passed at %0t: out = 00", $time);
        end
        if (is_zero !== 1'b1) begin
            $display("Test Case 2 Failed at %0t: Expected is_zero = 1, got %b", $time, is_zero);
        end else begin
            $display("Test Case 2 Passed at %0t: is_zero = 1", $time);
        end

        // Test Case 3: ADD (opcode 010)
        $display("Test Case 3: ADD (opcode 010)");
        opcode = 3'b010;
        inA = 8'h05;  // 5
        inB = 8'h03;  // 3
        #10;
        if (out !== 8'h08) begin
            $display("Test Case 3 Failed at %0t: Expected out = 08, got %h", $time, out);
        end else begin
            $display("Test Case 3 Passed at %0t: out = 08", $time);
        end
        if (is_zero !== 1'b0) begin
            $display("Test Case 3 Failed at %0t: Expected is_zero = 0, got %b", $time, is_zero);
        end else begin
            $display("Test Case 3 Passed at %0t: is_zero = 0", $time);
        end

        // Test Case 4: AND (opcode 011)
        $display("Test Case 4: AND (opcode 011)");
        opcode = 3'b011;
        inA = 8'hF0;  // 11110000
        inB = 8'hAA;  // 10101010
        #10;
        if (out !== 8'hA0) begin
            $display("Test Case 4 Failed at %0t: Expected out = A0, got %h", $time, out);
        end else begin
            $display("Test Case 4 Passed at %0t: out = A0", $time);
        end
        if (is_zero !== 1'b0) begin
            $display("Test Case 4 Failed at %0t: Expected is_zero = 0, got %b", $time, is_zero);
        end else begin
            $display("Test Case 4 Passed at %0t: is_zero = 0", $time);
        end

        // Test Case 5: XOR (opcode 100)
        $display("Test Case 5: XOR (opcode 100)");
        opcode = 3'b100;
        inA = 8'hF0;  // 11110000
        inB = 8'hAA;  // 10101010
        #10;
        if (out !== 8'h5A) begin
            $display("Test Case 5 Failed at %0t: Expected out = 5A, got %h", $time, out);
        end else begin
            $display("Test Case 5 Passed at %0t: out = 5A", $time);
        end
        if (is_zero !== 1'b0) begin
            $display("Test Case 5 Failed at %0t: Expected is_zero = 0, got %b", $time, is_zero);
        end else begin
            $display("Test Case 5 Passed at %0t: is_zero = 0", $time);
        end

        // Test Case 6: LDA (opcode 101)
        $display("Test Case 6: LDA (opcode 101)");
        opcode = 3'b101;
        inA = 8'hFF;  // Không dùng
        inB = 8'h42;  // D? li?u t? b? nh?
        #10;
        if (out !== 8'h42) begin
            $display("Test Case 6 Failed at %0t: Expected out = 42, got %h", $time, out);
        end else begin
            $display("Test Case 6 Passed at %0t: out = 42", $time);
        end
        if (is_zero !== 1'b0) begin
            $display("Test Case 6 Failed at %0t: Expected is_zero = 0, got %b", $time, is_zero);
        end else begin
            $display("Test Case 6 Passed at %0t: is_zero = 0", $time);
        end

        // Test Case 7: STO (opcode 110)
        $display("Test Case 7: STO (opcode 110)");
        opcode = 3'b110;
        inA = 8'h77;  // Accumulator = 0x77
        inB = 8'hFF;  // Không dùng
        #10;
        if (out !== 8'h77) begin
            $display("Test Case 7 Failed at %0t: Expected out = 77, got %h", $time, out);
        end else begin
            $display("Test Case 7 Passed at %0t: out = 77", $time);
        end
        if (is_zero !== 1'b0) begin
            $display("Test Case 7 Failed at %0t: Expected is_zero = 0, got %b", $time, is_zero);
        end else begin
            $display("Test Case 7 Passed at %0t: is_zero = 0", $time);
        end

        // Test Case 8: JMP (opcode 111)
        $display("Test Case 8: JMP (opcode 111)");
        opcode = 3'b111;
        inA = 8'h00;  // Accumulator = 0x00
        inB = 8'hFF;  // Không dùng
        #10;
        if (out !== 8'h00) begin
            $display("Test Case 8 Failed at %0t: Expected out = 00, got %h", $time, out);
        end else begin
            $display("Test Case 8 Passed at %0t: out = 00", $time);
        end
        if (is_zero !== 1'b1) begin
            $display("Test Case 8 Failed at %0t: Expected is_zero = 1, got %b", $time, is_zero);
        end else begin
            $display("Test Case 8 Passed at %0t: is_zero = 1", $time);
        end

        // Test Case 9: Default case (invalid opcode)
        $display("Test Case 9: Default case (invalid opcode)");
        opcode = 3'b111 + 1;  // Opcode không h?p l?
        inA = 8'h00;
        inB = 8'hFF;
        #10;
        if (out !== 8'h00) begin
            $display("Test Case 9 Failed at %0t: Expected out = 00, got %h", $time, out);
        end else begin
            $display("Test Case 9 Passed at %0t: out = 00", $time);
        end
        if (is_zero !== 1'b1) begin
            $display("Test Case 9 Failed at %0t: Expected is_zero = 1, got %b", $time, is_zero);
        end else begin
            $display("Test Case 9 Passed at %0t: is_zero = 1", $time);
        end

        // K?t thúc mô ph?ng
        $display("Simulation completed!");
        $stop;
    end

    // Monitor ð? quan sát các tín hi?u
    initial begin
        $monitor("Time=%0t | opcode=%b | inA=%h | inB=%h | out=%h | is_zero=%b",
                 $time, opcode, inA, inB, out, is_zero);
    end

endmodule
