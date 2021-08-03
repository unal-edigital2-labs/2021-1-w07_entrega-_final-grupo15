module UartTx(
	input Clock,
	input ClockBAUD,
	input Reset,
	input TxInit,
	input [7:0] TxData,
	output reg Tx=1'b1,
	output reg TxDone=1'b1
);
localparam WAIT=2'b00, START=2'b01, DATA=2'b10, STOP=2'b11;


wire VarClock;
assign VarClock=(Reset==1'b1) ? Clock:ClockBAUD;

reg Sync=1'b0;
reg [3:0] Dcounter=1'b0;
reg [7:0] Data=1'b0;
reg [1:0] Status=WAIT;



always @(posedge VarClock)begin

if(Reset==1'b1)begin
	Sync<=1'b0;
	Tx<=1'b1;
	Dcounter<=1'b0;
	Data<=1'b0;
	TxDone<=1'b0;
	Status<=WAIT;
end
else begin




	case(Status)
	
	
	
		WAIT:begin
		
			Sync=1'b0;
			Tx<=1'b1;
			Dcounter=1'b0;
			if(TxInit==1'b0) TxDone=1'b0;
			else if(TxDone==1'b0) Status<=START;	
		
		end
		
		START:begin
			Tx=1'b0;
			Data<=TxData;
			Dcounter<=4'd8;
			
			if(Sync==1'b1) Status<=DATA;

			Sync=Sync+1'b1;
		
		end
		
		DATA:begin
			
			
			if(Sync==1'b0)begin
				Tx<=Data[0];
				Data <= Data >> 1'b1;
				Dcounter<=Dcounter-1'b1;	
			end
			else if(Dcounter==1'b0) Status<=STOP;
			
			Sync<=Sync+1'b1;
		
		end
		
		STOP:begin
		
			Tx<=1'b1;
			TxDone<=1'b1;
			if(Sync==1'b1)Status<=WAIT;
			Sync<=Sync+1'b1;
		
		end
		
		default:Status<=WAIT;
		
	endcase
	

	
	
	
	
end

end









endmodule
