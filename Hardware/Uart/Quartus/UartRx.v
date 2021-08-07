module UartRx(
	input Clock,
	input ClockBAUD,
	input Reset,
	input Rx,
	output reg [7:0] RxData=1'b0,
	output reg RxAvailable=1'b0
);
localparam WAIT=2'b00, START=2'b01, DATA=2'b10, STOP=2'b11;


wire VarClock;
assign VarClock=(Reset==1'b1) ? Clock:ClockBAUD;

reg Sync=1'b0;
reg [3:0] Dcounter=1'b0;
reg [1:0] Status=WAIT;



always @(posedge VarClock)begin

if(Reset==1'b1)begin
	Sync<=1'b0;
	RxData<=1'b0;
	Dcounter<=1'b0;
	Status<=WAIT;
	RxAvailable<=1'b0;
end
else begin




	case(Status)
	
	
	
		WAIT:begin
		
			Sync<=1'b0;
			Dcounter<=1'b0;
			if(Rx==1'b0) begin
				RxAvailable<=1'b0;
				RxData<=1'b0;
				Status<=START;	
			end
			
		end
		
		START:begin
			Dcounter<=4'd8;
			if(Sync==1'b1) Status<=DATA;

			Sync<=Sync+1'b1;
		
		end
		
		DATA:begin
			
			
			if(Sync==1'b0)begin
				RxData[7]<=Rx;
				Dcounter<=Dcounter-1'b1;	
			end
			else if(Dcounter==1'b0) Status<=STOP;
			else 	RxData <= RxData >> 1'b1;
			
			Sync<=Sync+1'b1;
		
		end
		
		STOP:begin
			RxAvailable<=1'b1;

			if(Sync==1'b1)begin
				if(Rx!=1'b1)begin
					RxData<=1'b0;
					RxAvailable<=1'b0;
				end			
					
			Sync<=Sync+1'b1;
			end else Status<=WAIT;

		
		end
		
		default:Status<=WAIT;
		
	endcase
	

	
	
	
	
end

end









endmodule
