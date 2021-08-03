module motores(
	input clk,
	input rst,
	input [2:0] movimiento,
	output pwm1,
	output pwm2,
	output [1:0] motorA,
	output [1:0] motorB
);


PWM First(clk, !rst, 7'd20, pwm1);
PWM Second(clk, !rst, 7'd20, pwm2);
Direcciones Dir(movimiento, motorA, motorB);

endmodule 
