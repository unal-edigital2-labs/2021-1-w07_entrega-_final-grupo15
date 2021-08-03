`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.11.2020 08:35:50
// Design Name: 
// Module Name: PWM
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


module counter( 
  input clk, 
  input reset,
  output reg [15:0] count
);

initial  begin
count = 0; 
end 
always@(negedge clk)
begin 
    if(reset) count<=16'b0;
    else count<=count+16'b1;
end    
endmodule
