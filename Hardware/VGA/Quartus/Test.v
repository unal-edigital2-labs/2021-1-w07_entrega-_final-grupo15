module Test(
	input Clock,
	input Reset,
	output [11:0] RGB,
	output Hsync,
	output Vsync
);


wire WriteClock;
wire [11:0] DataRamIn;
wire [14:0] AddrRamIn;

wire ReadClock;
wire [11:0] DataRamOut;
reg [14:0] AddrRamOut=1'b0; 

wire [9:0] Xpixel;
wire [8:0] Ypixel;


ImBuffer #(12, 15,"Im.mem") Ram (DataRamIn, AddrRamOut, AddrRamIn, 1'b0, ReadClock, WriteClock, DataRamOut);

VGA_Driver640x480 VGA(!Reset, ReadClock, DataRamOut,  RGB, Hsync, Vsync, Xpixel, Ypixel);

DivisorFrecuencia CLK25(Clock,!Reset,ReadClock);


always @ (Xpixel, Ypixel) begin
		if ((Xpixel>176-1) || (Ypixel>144-1))
			AddrRamOut=15'b111111111111111;
		else
	                AddrRamOut = Xpixel + Ypixel * 176;
end


endmodule
