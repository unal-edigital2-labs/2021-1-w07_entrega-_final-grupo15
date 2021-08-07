module Test(
	input Clock,
	input Reset,
	input Start,
	input Pause,
	output Busy
);

Timmer xD(Clock, Reset, !Start, !Pause, 15'd256, Busy);
endmodule
