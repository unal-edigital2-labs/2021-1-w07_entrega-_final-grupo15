module PWM(
	input Clock, 
	input Reset,
	input [6:0] Duty,
	output reg PWM=1'b0
);

reg [9:0] BaseCounter=1'b0;
reg [6:0] Ticks=1'b0;

always @(posedge Clock)begin

	if(Reset==1'b0)begin
	
		BaseCounter<=BaseCounter+1'b1;
		if(BaseCounter==10'd999)begin
			Ticks<=Ticks+1'b1;
			BaseCounter<=1'b0;
			if(Ticks==12'd99)begin
				Ticks<=1'b0;
				PWM<=1'b1;
			end
			if(Ticks==Duty)PWM<=1'b0;
		end
		
		if(Duty==0)PWM<=1'b0;
	end
	else begin
		BaseCounter=1'b0;
		Ticks=1'b0;
		PWM=1'b0;
	end
end









endmodule
