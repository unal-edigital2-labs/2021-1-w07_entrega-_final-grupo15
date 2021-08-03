module DivisorFrecuencia(
	input Clock,
	input Reset,
	output reg Clock25M=1'b0
);


always @(posedge Clock)begin
	if(Reset==1'b0)begin
		Clock25M=!Clock25M;
	end
	else begin
		Clock25M=1'b0;
	end
end





endmodule
