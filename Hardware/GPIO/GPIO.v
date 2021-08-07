module GPIO (
	input Datain,
	input Control,
	output Dataout,
	
	inout Salida
);
	

assign Salida = (Control ? Datain : 1'bZ);
assign Dataout = Salida;


endmodule 