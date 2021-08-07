module GeneradorPulsos(
	input Clock,
	input Clock1M,
	input Reset,
	input Enable,
	output reg Trigger=1'b0,
	output reg Done=1'b0
);


reg [3:0] Contador=1'b0;

wire VarClock;
assign VarClock = (Reset==1'b1) ? Clock:Clock1M;

always @(posedge VarClock)begin
	if(Reset==1'b0)begin
		if(Enable==1'b1)begin
			
			Contador=Contador+1'b1;
			
			if(Contador==4'd11)begin
				Contador=1'b0;
				Done=1'b1;
			end
			else Done=1'b0;


						
			if(Contador==1'b0) Trigger=1'b0;
			else Trigger=1'b1;
		end
	end
	
	if(Reset==1'b1 || Enable==1'b0)begin 
		Contador=1'b0;
		Trigger=1'b0;
		Done=1'b0;
	end
end



endmodule
