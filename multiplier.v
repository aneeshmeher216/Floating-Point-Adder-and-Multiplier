`timescale 1ns / 1ps
// Create Date: 07.12.2025 13:22:53
// Description: Single Precision(32-bit) Floating Point Multiplier 

module multiplier(
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);
reg sign_a, sign_b;
reg [7:0] exp_a, exp_b;
reg [23:0] mantissa_a, mantissa_b;

reg sign_result;
reg [7:0] exp_result;   
reg [47:0] mantissa_result; //mutliplication of 2 24-bit mantissa can be at most 48-bit

always @(*) begin
    sign_a = a[31];    
    sign_b = b[31];    
    exp_a = a[30:23];
    exp_b = b[30:23];
    mantissa_a = {1'b1,a[22:0]};
    mantissa_b = {1'b1,b[22:0]};
end

always @(*) begin
    sign_result = sign_a ^ sign_b;
    exp_result = exp_a + exp_b - 8'd127;
    mantissa_result = mantissa_a * mantissa_b;
    
    if(mantissa_result[47] == 1) begin      //implies the resulting number is greater than 
        mantissa_result = mantissa_result >> 1;
        exp_result = exp_result + 1'b1;
    end
end

assign result = {sign_result, exp_result, mantissa_result[45:23]}; 

endmodule
