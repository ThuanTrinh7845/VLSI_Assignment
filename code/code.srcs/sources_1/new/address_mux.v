`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 09:11:06 AM
// Design Name: 
// Module Name: address_mux
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


module address_mux #(
    parameter WIDTH = 5  // Ð? r?ng m?c ð?nh là 5 bit
) (
    input wire sel,              // Tín hi?u ch?n
    input wire [WIDTH-1:0] addr_in0,  // Ð?a ch? toán h?ng
    input wire [WIDTH-1:0] addr_in1,  // Ð?a ch? l?nh (t? PC)
    output wire [WIDTH-1:0] addr_out  // Ð?a ch? ð?u ra
);

    assign addr_out = (sel) ? addr_in1 : addr_in0;  // Ch?n ð?a ch? d?a trên sel

endmodule
