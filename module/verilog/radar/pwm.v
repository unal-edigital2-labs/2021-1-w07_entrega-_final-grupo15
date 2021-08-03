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


module pwm( 
  input clk, 
  input enable,
  input [15:0] dutty,  // dutty en microsegundos
  input [15:0] period, // periodo en microsegundos
 // input [1:0] dutty_dir,  // provisional para prueba
  output reg pwm_out
);

//provisional para prueba
//reg [15:0] dutty;
//reg [15:0] period;
//fin de provisional para prueba

wire clk_1M;

reg counter_reset;
wire [15:0] count;

reg [1:0] state;

initial begin
	pwm_out<=0;
	state<=0;
	
//provisional para prueba
//    dutty<= 16'd1_000; //1ms -90 grados
 //   period<= 16'd20_000;
//fin de provisional para prueba
end
	
// máquina de estados

always@(posedge clk_1M)
begin

//provisional para prueba
//if(dutty_dir==0)dutty<=16'd1500;
//if(dutty_dir==1)dutty<=16'd1000;
//if(dutty_dir==2)dutty<=16'd2000;
//fin de provisional para prueba


    if (!enable) begin
			pwm_out<=0;
            state <= 0;
    end
	case(state)
		0: begin
			pwm_out<=0;
			counter_reset<=1;
			
            if(enable)
    	       state<=1;
		end

		1: begin
		
			pwm_out<=1;
			counter_reset<=0;
			if(count>=dutty)
    	       state<=2;
  		end

		2: begin
			    pwm_out<=0;
				if(count>=period)begin
            	   state<=0;      	
            	end
    
		end
	endcase
end


clk_div #(.MAX_COUNT(50)) clk1_1M (.clk(clk), .clk_out(clk_1M));
counter counter1(.clk(clk_1M), .count(count), .reset(counter_reset));


endmodule
