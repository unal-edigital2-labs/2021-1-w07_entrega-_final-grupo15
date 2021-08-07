module Pruebas (
		input Clock,
		input Reset,
		input Rx,
		output Tx
);


wire RxDone;
wire [7:0] RxData;
reg [7:0] TxData=8'd32;
reg Rxen=1'b0;
wire TxDone;


reg[50:0] Counter=1'b0;

TOP Top(Clock, Reset, Rx, Tx, RxData,TxData,TxDone,RxDone,Rxen);

always @(posedge Clock)begin

if(TxDone==1)Rxen=0;

if(Counter==51'd50000000) begin
	Counter=1'b0;
	Rxen=1;
end

if(RxDone==1)begin

Counter=Counter+1'b1;

TxData=RxData+1'b1;
end

end














endmodule
