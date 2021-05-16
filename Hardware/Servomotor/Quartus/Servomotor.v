module Servomotor(
	input Clock, 
	input [15:0] Periodo,
	input [11:0] Ciclo,
	output reg Out
);

reg [15:0] BaseCounter=1'b0;
reg [11:0] Ticks=1'b0;

always @(posedge Clock)begin

	BaseCounter<=BaseCounter+1'b1;
	if(BaseCounter==Periodo)begin
		Ticks<=Ticks+1'b1;
		BaseCounter<=1'b0;
		if(Ticks==12'd3999)begin
			Ticks<=1'b0;
			Out<=1'b1;
		end
		if(Ticks==Ciclo)Out<=1'b0;
	end
	
	if(Ciclo==0)Out<=1'b0;
	
end









endmodule
