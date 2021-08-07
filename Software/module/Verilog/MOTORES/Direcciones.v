module Direcciones(
	input [2:0] Movimiento,
	output [1:0] MotorA,
	output [1:0] MotorB
);

assign MotorA[1]=(Movimiento[0]&(Movimiento[2]));
assign MotorA[0]=(Movimiento[0]&(!Movimiento[2]));

assign MotorB[1]=(Movimiento[1]&(Movimiento[2]));
assign MotorB[0]=(Movimiento[1]&(!Movimiento[2]));


endmodule
