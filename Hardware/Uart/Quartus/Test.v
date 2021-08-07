module Test(
		input Clock,
		input Reset,
		input Rx,
		output Tx
);

wire [7:0] RxData;
reg [7:0] TxData=8'd32;
reg TxInit=1'b1;
wire TxDone;
wire RxAvailable;



reg[50:0] Counter=1'b0;






Uart Top(Clock, !Reset, 16'd1302, TxInit, TxData, Rx, RxData, Tx, TxDone, RxAvailable);






















always @(posedge Clock)begin

if(TxDone==1'b1)TxInit=1'b0;

if(Counter==51'd50000000) begin
	Counter=1'b0;
	TxInit=1;
end

//if (TxInit==1'b0)


if(RxAvailable==1)begin
Counter=Counter+1'b1;
TxData=RxData+1'b1;
end

end

endmodule 