module OV7670(
	input Reset,
	output reg [11:0]  PixelData=1'b0,
	output [14:0] PAddress,
	output reg WPixel=1'b0,
	input Pclock,
	input Href,
	input Vsync,
	input [7:0] Data
);


reg Href_prev=1'b0;
reg [7:0] XPixel=1'b0;
reg [7:0] YPixel=1'b0;
reg Sync=1'b0;

assign PAddress = XPixel + YPixel*8'd176;
 

always @(posedge Pclock)begin


if(Reset==1'b1)begin
	PixelData=1'b0 
	WPixel=1'b0;
	Href_prev=1'b0;
	XPixel=1'b0;
	YPixel=1'b0;
	Sync=1'b0;
end
else begin

	if(Vsync==1'b1)begin
		Sync=1'b0;
		WPixel=1'b0;
		XPixel=1'b0;
		YPixel=1'b0;
	end
	else if(Href==1'b0 && Href_prev==1'b1)begin
		Sync=1'b0;
		WPixel=1'b0;
		XPixel=1'b0;
		YPixel=YPixel+1'b1;
	end
	else if(Href==1'b1)begin
		if(Sync==1'b0)begin
			PixelData[11:4]=Data;
			Sync=1'b1;
			WPixel=1'b0;
		end
		else begin
			PixelData[3:0]=Data[7:4];
			XPixel=XPixel+1'b1;
			Sync=1'b0;
			WPixel=1'b1;
		end
	end
	
	
	Href_prev=Href;
	
	if ((XPixel>8'd176-1'b1) || (YPixel>8'd144-1'b1)) PixelData=1'b0;


end



end



endmodule
