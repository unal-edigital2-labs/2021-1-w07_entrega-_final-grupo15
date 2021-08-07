module Motores(
	input Clock,
	input Reset,
	input [2:0] Movimiento,
	output PWM1,
	output PWM2,
	output [1:0] MotorA,
	output [1:0] MotorB
);


PWM First(Clock, !Reset, 7'd20, PWM1);
PWM Second(Clock, !Reset, 7'd20, PWM2);
Direcciones Dir(Movimiento, MotorA, MotorB);

endmodule 
