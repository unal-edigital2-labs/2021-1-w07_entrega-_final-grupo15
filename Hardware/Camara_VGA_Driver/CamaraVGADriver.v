module CamaraVGADriver(
	input Clock,
	input Reset,
	
	//Camara
	input Pclock,
	input Href,
	input Vsync_cam,
	input [7:0] Data,
	input PauseCam,
	output XClock,
	
	//Camara Ram
	output [14:0] SystemCamAddr,
	output [11:0] SystemCamDataOut,
	
	//Mapa Ram
	input [3:0] MapaData,
	input [5:0] MapaAddr,
	input MapaWrite,
	
//	input [3:0] SystemMapAddr,
//	output [5:0] SystemMapDataOut,
	
	//Procesamiento de imagen
	output wire [1:0] Forma,
	output wire [1:0] PromedioColor,

	
	
	//VGA
	output [11:0] RGB,
	output Hsync,
	output Vsync
);

assign SystemCamAddr = AddrCamOut;
assign SystemCamDataOut = DataCamOut;


//Write Cam
wire [11:0] PixelDataCam;
wire [14:0] PixelAddrCam;
wire WPixelCam;

wire Wpixel; //True Write Cam



//VGA-Cam
wire [11:0] DataCamOut;
wire [14:0] AddrCamOut; 




//VGA 
wire [11:0] PixelData;
wire [9:0] Xpixel;
wire [8:0] Ypixel;



reg [11:0] Colores=1'b0;
reg [2:0] CounterX=1'b0;
reg [2:0] CounterY=1'b0;
wire [5:0] AddrMapaOut;
wire [3:0] DataMapaOut;



reg [11:0] ColoresProm=1'b0;
reg [11:0] ColoresForma=1'b0;



assign AddrMapaOut=(((Xpixel<10'd450)&&(Xpixel>10'd9)) &&	((Ypixel<10'd460)&&(Ypixel>10'd19)))?(CounterX+CounterY*4'd8):1'b0;
assign AddrCamOut=(((Xpixel<10'd629)&&(Xpixel>10'd452)) &&	((Ypixel<9'd311)&&(Ypixel>9'd166)))?((Xpixel-10'd453)+(Ypixel-9'd167)*9'd176):1'b0;

assign PixelData=(((Xpixel==10'd590)&&(Ypixel<9'd288) && (Ypixel>9'd188)) || ((Xpixel==10'd490)&&(Ypixel<9'd288) && (Ypixel>9'd188)) || ((Ypixel==9'd288)&&(Xpixel<10'd590) && (Xpixel>10'd490)) || ((Ypixel==9'd188)&&(Xpixel<10'd590) && (Xpixel>10'd490)))?12'hF00:(((Xpixel<10'd629)&&(Xpixel>10'd452)) && ((Ypixel<9'd311)&&(Ypixel>9'd166)))?DataCamOut:((((Xpixel<10'd450)&&(Xpixel>10'd9)) &&	((Ypixel<10'd460)&&(Ypixel>10'd19)))?Colores:(Ypixel>10'd240)?ColoresProm:ColoresForma);

assign Wpixel=(PauseCam==1'b1) ? 1'b0:WPixelCam;

ImBuffer #(12, 15,"Im.mem") Camara (PixelDataCam, AddrCamOut, PixelAddrCam, Wpixel, XClock, Pclock, DataCamOut);
ImBufferv2 #(4, 6,"Mapa.mem") Mapa (MapaData, AddrMapaOut, MapaAddr, MapaWrite, Clock, Pclock, DataMapaOut);


VGA_Driver640x480 VGA(!Reset, XClock, PixelData, RGB, Hsync, Vsync, Xpixel, Ypixel);

DivisorFrecuencia CLK25(Clock,!Reset,XClock);

OV7670 Cam(!Reset, PixelDataCam, PixelAddrCam, WPixelCam, Pclock, Href, Vsync_cam, Data, PromedioColor,Forma);

always @ (Xpixel, Ypixel) begin
		

		if (((Xpixel<10'd450)&&(Xpixel>10'd9)) &&	((Ypixel<10'd460)&&(Ypixel>10'd19))) begin
	
			if(Xpixel<10'd65) CounterX=3'd0;
			else if (Xpixel<10'd120) CounterX=3'd1;
			else if (Xpixel<10'd175) CounterX=3'd2;
			else if (Xpixel<10'd230) CounterX=3'd3;
			else if (Xpixel<10'd285) CounterX=3'd4;
			else if (Xpixel<10'd340) CounterX=3'd5;
			else if (Xpixel<10'd395) CounterX=3'd6;
			else if (Xpixel<10'd450) CounterX=3'd7;
			
			if(Ypixel<10'd75) CounterY=3'd0;
			else if (Ypixel<10'd130) CounterY=3'd1;
			else if (Ypixel<10'd185) CounterY=3'd2;
			else if (Ypixel<10'd240) CounterY=3'd3;
			else if (Ypixel<10'd295) CounterY=3'd4;
			else if (Ypixel<10'd350) CounterY=3'd5;
			else if (Ypixel<10'd405) CounterY=3'd6;
			else if (Ypixel<10'd460) CounterY=3'd7;
			
		end
			
		case(DataMapaOut)
		
		3'b000:Colores=12'h000;
		3'b001:Colores=12'h5FF;
		3'b010:Colores=12'hAFc;
		3'b011:Colores=12'hA0A;
		3'b100:Colores=12'hA00;
		3'b101:Colores=12'h0A0;
		3'b110:Colores=12'h00A;
		default:Colores=12'h000;
		
		endcase
		
		case(PromedioColor)
		
		2'b00:ColoresProm=12'h000;
		2'b01:ColoresProm=12'hF00;
		2'b10:ColoresProm=12'h0F0;
		2'b11:ColoresProm=12'h00F;
		default:ColoresProm=12'h000;
		
		endcase
		
		case(Forma)
		
		2'b00:ColoresForma=12'h000;
		2'b01:ColoresForma=12'hF00;
		2'b10:ColoresForma=12'h0F0;
		2'b11:ColoresForma=12'h00F;
		default:ColoresForma=12'h000;
		
		endcase


			
end


endmodule
