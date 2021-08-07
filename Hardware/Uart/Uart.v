module Uart(
	input Clock,
	input Reset,
	input [15:0] Baudios,
	input TxInit,
	input [7:0] TxData,
	input Rx,
	output [7:0] RxData,
	output Tx,
	output TxDone,
	output RxAvailable
);

wire ClockBAUD;


UartTx Transmission(Clock, ClockBAUD, Reset, TxInit, TxData, Tx, TxDone);
UartRx Receive(Clock, ClockBAUD, Reset, Rx, RxData, RxAvailable);
GeneradorBaudios Baud(Clock, Reset, Baudios, ClockBAUD);




	



endmodule
