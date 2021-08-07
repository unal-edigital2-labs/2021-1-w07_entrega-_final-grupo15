module Timmer(
	input Clock,
	input Reset,
	input Start,
	input Pause,
	input [15:0] Tiempo,
	output Busy
);




reg [15:0] Counter=1'b0;
reg [1:0] Status=1'b0;
localparam WAIT=0, COUNT=1, PAUSE=2; 

assign Busy=(Status==COUNT);


always @(posedge Clock)begin


if(Reset==1'b1)begin
	Counter=1'b0;
	Status=1'b0;
end
else begin
	case(Status)
		WAIT:begin
			Counter=1'b0;
			if(Pause==1'b0 && Start==1'b1)begin
				Counter=Tiempo;
				Status=COUNT; 
			end
		end
		
		
		COUNT:begin
			if(Counter==1'b0)Status=WAIT;
			else if(Pause==1'b1)Status=PAUSE;
			else	Counter=Counter-1'b1;

		end
		
		PAUSE:begin
			if(Pause==1'b0)begin
				Status=COUNT;
				Counter=Counter-1'b1;
			end
		end
		
		default: Status=WAIT;
	
	endcase
end


end

endmodule

 