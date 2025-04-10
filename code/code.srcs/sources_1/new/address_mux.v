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
    parameter WIDTH = 5  // �? r?ng m?c �?nh l� 5 bit
) (
    input wire sel,              // T�n hi?u ch?n
    input wire [WIDTH-1:0] addr_in0,  // �?a ch? to�n h?ng
    input wire [WIDTH-1:0] addr_in1,  // �?a ch? l?nh (t? PC)
    output wire [WIDTH-1:0] addr_out  // �?a ch? �?u ra
);

    assign addr_out = (sel) ? addr_in1 : addr_in0;  // Ch?n �?a ch? d?a tr�n sel

endmodule
