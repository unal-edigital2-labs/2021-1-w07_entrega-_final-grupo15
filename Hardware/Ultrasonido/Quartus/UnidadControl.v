module UnidadControl(
	input Inicio,
	input Reset,
	input Clock,
	input DoneGenPulsos,
	input DoneDistancia,
	output reg EnablGenPulsos=1'b0,
	output reg EnableDistancia=1'b0,
	output reg ClearDistancia=1'b1
);

reg [1:0] Status=1'b0;

localparam Wait=0, Pulso=1, Distancia=2;

always @(posedge Clock)begin
	if(Reset==1'b0)begin
		case(Status)
			Wait:begin
				EnablGenPulsos=1'b0;
				EnableDistancia=1'b0;
				ClearDistancia=1'b0;
				if(Inicio==1'b1)Status=Pulso;
			end
			
			Pulso:begin
				EnablGenPulsos=1'b1;
				EnableDistancia=1'b0;
				ClearDistancia=1'b1;
				if(DoneGenPulsos==1'b1)Status=Distancia;
			end
			
			Distancia:begin
				EnablGenPulsos=1'b0;
				EnableDistancia=1'b1;
				ClearDistancia=1'b0;
				if(DoneDistancia==1'b1)Status=Wait;
			end
			
			default:Status=Wait;
			
		endcase	
		
		
		
	end
	else begin
		EnablGenPulsos=1'b0;
		EnableDistancia=1'b0;
		ClearDistancia=1'b1;
		Status=1'b0;
	end
end	

endmodule


