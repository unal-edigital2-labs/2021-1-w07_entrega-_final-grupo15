module Test(
	input Clock,
	input Reset,
	input Pclock,
	input Href,
	input Vsync_cam,
	input [7:0] Data,
	output [11:0] RGB,
	output Hsync,
	output Vsync,
	output XClock
);

wire [11:0] PixelData;
wire [14:0] AddrRamIn;
wire WPixel;

wire [11:0] DataRamOut;
reg [14:0] AddrRamOut=1'b0; 

wire [9:0] Xpixel;
wire [8:0] Ypixel;


ImBuffer #(12, 15,"Im.mem") Ram (PixelData, AddrRamOut, AddrRamIn, WPixel, XClock, Pclock, DataRamOut);

VGA_Driver640x480 VGA(!Reset, XClock, DataRamOut, RGB, Hsync, Vsync, Xpixel, Ypixel);

DivisorFrecuencia CLK25(Clock,!Reset,XClock);

OV7670 Cam(!Reset, PixelData, AddrRamIn, WPixel, Pclock, Href, Vsync_cam, Data);

always @ (Xpixel, Ypixel) begin
		if ((Xpixel>8'd176-1'b1) || (Ypixel>8'd144-1'b1))
			AddrRamOut=15'b111111111111111;
		else
	                AddrRamOut = Xpixel + Ypixel * 8'd176;
end


endmodule
