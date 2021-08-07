module GeneradorBaudios(
	input Clock,
	input Reset,
	input [15:0] Baudios,
	output reg ClockBAUD=1'b0
);

reg [15:0] Contador=1'b0;

always @(posedge Clock) begin

if(Reset==1'b1)begin
	Contador=1'b0;
	ClockBAUD=1'b0;
end
else begin
	
	if(Contador==Baudios)begin
		Contador=1'b0;
		ClockBAUD=!ClockBAUD;
	end
	else Contador=Contador+1'b1;
end

end

endmodule
