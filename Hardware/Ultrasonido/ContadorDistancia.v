module ContadorDistancia (
	input Clock,
	input Clock1M,
	input Reset,
	input Clear,
	input Enable,
	input Echo,
	output reg [8:0] Distancia=1'b0,
	output reg Done=1'b0
);


reg [5:0] Contador=1'b0;

wire Varclock;
assign Varclock=(Reset==1'b1) ? Clock:Clock1M;

always @(posedge Varclock)begin
	if(Reset==1'b0)begin
		
		if(Clear==1'b1)begin
			Done=1'b0;
			Distancia=1'b0;
			Contador=1'b0;
		end
		
		if(Enable==1'b1)begin
			
			if(Echo==1'b1)begin
				Contador=Contador+1'b1;
				Done=1'b0;	
			end
			
			else begin
				if(Distancia!=0)begin
					Done=1'b1;
					Contador=1'b0;
				end				
			end
			
			if(Contador==6'd58)begin
				Contador=1'b1;
				Distancia=Distancia+1'b1;
			end
		end
		
		else begin
			Contador=1'b0;
		end
	
	end
	else begin
		Done=1'b0;
		Contador=1'b0;
		Distancia=1'b0;
	end
end



endmodule
