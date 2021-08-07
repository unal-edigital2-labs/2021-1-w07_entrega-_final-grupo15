module DivisorFrecuencia(
	input Clock,
	input Reset,
	output reg Clock1M=1'b0
);

reg [4:0] Contador=1'b0;

always @(posedge Clock)begin
	if(Reset==1'b0)begin
		Contador=Contador+1'b1;
		if(Contador==5'd25)begin
			Contador=1'b0;
			Clock1M=!Clock1M;
		end
	end
	else begin
		Contador=1'b0;
		Clock1M=1'b0;
	end
end





endmodule
