module OV7670(
	input Reset,
	output reg [11:0]  PixelData=1'b0,
	output [14:0] PAddress,
	output reg WPixel=1'b0,
	input Pclock,
	input Href,
	input Vsync,
	input [7:0] Data,
	output reg [1:0] Promedio=1'b0,
	output reg [1:0] Forma=1'b0
);


reg Href_prev=1'b0;
reg [7:0] XPixel=1'b0;
reg [7:0] YPixel=1'b0;
reg [11:0] Promedio_Color_R=1'b0;
reg [11:0] Promedio_Color_G=1'b0;
reg [11:0] Promedio_Color_B=1'b0;
reg VSync_prev=1'b0;
reg Sync=1'b0;


reg [1:0] Pixel_Valido_R=1'b0;
reg [1:0] Pixel_Valido_G=1'b0;
reg [1:0] Pixel_Valido_B=1'b0;

reg [5:0] Ancho_R=1'b0; 
reg [5:0] Ancho_G=1'b0;
reg [5:0] Ancho_B=1'b0;
reg [5:0] Ancho_R_Prev=1'b0; 
reg [5:0] Ancho_G_Prev=1'b0; 
reg [5:0] Ancho_B_Prev=1'b0; 
reg [7:0] Inc_Ancho_R=1'b0;
reg [7:0] Inc_Ancho_G=1'b0;
reg [7:0] Inc_Ancho_B=1'b0;
reg [7:0] MAX_Ancho_R=1'b0;
reg [7:0] Max_Ancho_G=1'b0;
reg [7:0] Max_Ancho_B=1'b0;


assign PAddress = XPixel + YPixel*8'd176;



always @(posedge Pclock)begin


if(Reset==1'b1)begin
	WPixel=1'b0;
	Href_prev=1'b0;
	VSync_prev=1'b0;
	XPixel=1'b0;
	YPixel=1'b0;
	Sync=1'b0;
	PixelData=1'b0;
	
	
	Promedio_Color_R=1'b0;
	Promedio_Color_G=1'b0;
	Promedio_Color_B=1'b0;
	Promedio=1'b0;
	
	
	
	Pixel_Valido_R=1'b0;
	Pixel_Valido_G=1'b0;
	Pixel_Valido_B=1'b0;
	
	Ancho_R=1'b0; 
	Ancho_G=1'b0;
	Ancho_B=1'b0;
	Ancho_R_Prev=1'b0; 
	Ancho_G_Prev=1'b0; 
	Ancho_B_Prev=1'b0; 
	Inc_Ancho_R=1'b0;
	Inc_Ancho_G=1'b0;
	Inc_Ancho_B=1'b0;
	MAX_Ancho_R=1'b0;
	Max_Ancho_G=1'b0;
	Max_Ancho_B=1'b0;

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
		
		
		
		//Incrementos del contador de Ancho
		if(Ancho_R>Ancho_R_Prev)Inc_Ancho_R=Inc_Ancho_R+1'b1;
		else if(Ancho_R<Ancho_R_Prev)Inc_Ancho_R=Inc_Ancho_R-1'b1;
		
		if(Ancho_G>Ancho_G_Prev)Inc_Ancho_G=Inc_Ancho_G+1'b1;
		else if(Ancho_G<Ancho_G_Prev)Inc_Ancho_G=Inc_Ancho_G-1'b1;
		
		if(Ancho_B>Ancho_B_Prev)Inc_Ancho_B=Inc_Ancho_B+1'b1;
		else if(Ancho_B<Ancho_B_Prev)Inc_Ancho_B=Inc_Ancho_B-1'b1;
		
		//Mayor ancho
		if(Inc_Ancho_R>MAX_Ancho_R)MAX_Ancho_R=Inc_Ancho_R;
		if(Inc_Ancho_G>Max_Ancho_G)Max_Ancho_G=Inc_Ancho_G;
		if(Inc_Ancho_B>Max_Ancho_B)Max_Ancho_B=Inc_Ancho_B;
		
		
		//Reset Ancho cada Hsync dentro del VSync
		if(Vsync==1'b0 && VSync_prev==1'b0)begin
			Ancho_R_Prev=Ancho_R;
			Ancho_G_Prev=Ancho_G; 
			Ancho_B_Prev=Ancho_B;
			Ancho_R=1'b0; 
			Ancho_G=1'b0; 
			Ancho_B=1'b0; 		
		end

		
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
	
	
	
	
	
	
	if(WPixel==1'b1 && (XPixel<8'd138) && (XPixel>8'd38) && (YPixel<8'd122) && (YPixel>8'd22))begin
	
	
	//Conteo de 3 pixeles de igual proporcion de color seguidos
		if((PixelData[3:0]>PixelData[7:4]) && (PixelData[3:0]>PixelData[11:8]))begin
			Pixel_Valido_B=Pixel_Valido_B+1'b1;
			Pixel_Valido_G=1'b0;
			Pixel_Valido_R=1'b0;
		end
		else if((PixelData[7:4]>PixelData[3:0]) && (PixelData[7:4]>PixelData[11:8]))begin
			Pixel_Valido_G=Pixel_Valido_G+1'b1;
			Pixel_Valido_B=1'b0;
			Pixel_Valido_R=1'b0;
			
		end
		else if((PixelData[11:8]>PixelData[3:0]) && (PixelData[11:8]>PixelData[7:4]))begin
			Pixel_Valido_R=Pixel_Valido_R+1'b1;
			Pixel_Valido_G=1'b0;
			Pixel_Valido_B=1'b0;		
		end
		
		
		
		//Si existen 3 pixeles de proporcion de color seguidos
		if(Pixel_Valido_R==2'b11)begin
					Pixel_Valido_R=1'b0;
					Promedio_Color_R=Promedio_Color_R+1'b1;
					Ancho_R=Ancho_R+1'b1;
		end
		if(Pixel_Valido_G==2'b11)begin
					Pixel_Valido_G=1'b0;
					Promedio_Color_G=Promedio_Color_G+1'b1;
					Ancho_G=Ancho_G+1'b1;
		end
		if(Pixel_Valido_B==2'b11)begin
					Pixel_Valido_B=1'b0;
					Promedio_Color_B=Promedio_Color_B+1'b1;
					Ancho_B=Ancho_B+1'b1;
		end

	end
	
	
	//Final de cada Imagen 
	if(Vsync==1'b1 && VSync_prev==1'b0)begin
		if(Promedio_Color_R>Promedio_Color_G && Promedio_Color_R>Promedio_Color_B)begin
			Promedio=2'b01;

			if(Inc_Ancho_R<(9'd100+9'd12) && Inc_Ancho_R>(9'd100-9'd12))begin
				if(Inc_Ancho_R<(MAX_Ancho_R-9'd12))Forma=2'b10;
				else Forma=2'b01;			   
			end
			else Forma=2'b11;			
			
		end
		else if(Promedio_Color_G>Promedio_Color_R && Promedio_Color_G>Promedio_Color_B)begin
			Promedio=2'b10;
			
			if(Inc_Ancho_G<(9'd100+9'd12) && Inc_Ancho_G>(9'd100-9'd12))begin
				if(Inc_Ancho_G<(Max_Ancho_G-9'd12))Forma=2'b10;
				else Forma=2'b01;			   
			end
			else Forma=2'b11;

		end
		else if(Promedio_Color_B>Promedio_Color_R && Promedio_Color_B>Promedio_Color_G)begin
			Promedio=2'b11;
			if(Inc_Ancho_B<(9'd100+9'd12) && Inc_Ancho_B>(9'd100-9'd12))begin
				if(Inc_Ancho_B<(Max_Ancho_B-9'd12))Forma=2'b10;
				else Forma=2'b01;			   
			end
			else Forma=2'b11;

		end
		else begin
			Promedio=2'b00;
			Forma=2'b00;
			
		end
		
		Promedio_Color_R=1'b0;
		Promedio_Color_G=1'b0;
		Promedio_Color_B=1'b0;
		Ancho_R=1'b0; 
		Ancho_G=1'b0;
		Ancho_B=1'b0;
		Ancho_R_Prev=1'b0; 
		Ancho_G_Prev=1'b0; 
		Ancho_B_Prev=1'b0; 
		Inc_Ancho_R=8'd100;
		Inc_Ancho_G=8'd100;
		Inc_Ancho_B=8'd100;
		MAX_Ancho_R=1'b0;
		Max_Ancho_G=1'b0;
		Max_Ancho_B=1'b0;
	
	end
	
	
	VSync_prev=Vsync;
	Href_prev=Href;
	
	if ((XPixel>8'd176-1'b1) || (YPixel>8'd144-1'b1)) PixelData=1'b0;


end



end



endmodule
