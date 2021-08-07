module Ultrasonido(
	input wire Clock,
	input wire Reset,
	input wire Inicio,
	input wire Echo,
	output wire Done,
	output wire Trigger,
	output wire [8:0] Distancia
);


wire DoneGenPulsos;
wire DoneDistancia;
wire EnablGenPulsos;
wire EnableDistancia;
wire ClearDistancia;
wire Clock1M;

DivisorFrecuencia CLK1M(Clock,Reset,Clock1M);

GeneradorPulsos Pulse(Clock,Clock1M,Reset,EnablGenPulsos ,Trigger,DoneGenPulsos);


ContadorDistancia Distance(Clock, Clock1M, Reset, ClearDistancia, EnableDistancia, Echo, Distancia, Done);


UnidadControl Control(Inicio, Reset, Clock, DoneGenPulsos, Done, EnablGenPulsos, EnableDistancia, ClearDistancia);

endmodule
