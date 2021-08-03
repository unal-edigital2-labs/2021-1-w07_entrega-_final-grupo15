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


module clk_div  #(parameter MAX_COUNT=50_000)
( 
  input clk,
  output reg clk_out
);

wire [15:0] count;
reg counter_reset;

initial begin
	clk_out<=0;
	counter_reset<=1;
end

always@(posedge clk)
  begin 
    counter_reset<=0;
    if(count==MAX_COUNT)
    begin
    	clk_out<=!clk_out;
    	counter_reset<=1;
    end
  end  

  counter counter1(.clk(clk), .count(count), .reset(counter_reset));
   

endmodule
  

