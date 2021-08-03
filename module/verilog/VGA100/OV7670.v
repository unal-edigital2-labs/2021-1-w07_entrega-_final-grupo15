module OV7670(
	input Reset,
	output reg [11:0]  PixelData=1'b0, // Salida de los 12 bits (4R, 4G, 4B) ya concatenados.
	output [14:0] PAddress, // Guardar en memoría la dirección asignada. 
	output reg WPixel=1'b0,
	input Pclock,
	input Href, // Protocolo VGA
	input Vsync, // Protocolo VGA
	input [7:0] Data, // Info de la camara (8 bits) --> envia en dos ciclos 4 -4 y luego en otro 4 y otro no validso
	output reg [1:0] Promedio=1'b0, //Color promedio
	output reg [1:0] Forma=1'b0 //Forma de la figura
);


reg Href_prev=1'b0;//Saber cuando Href cambia
	reg [7:0] XPixel=1'b0; //Información de la posición horizontal del pixel
	reg [7:0] YPixel=1'b0; //Información de la posición vertical del pixel
	reg [11:0] PromedioColorR=1'b0; //Aquí se realiza el registro de los trios de pixeles rojos que se encuentran en la imagen
	reg [11:0] PromedioColorG=1'b0; //Aquí se realiza el registro de los trios de pixeles verdes que se encuentran en la imagen
	reg [11:0] PromedioColorB=1'b0; //Aquí se realiza el registro de los trios de pixeles azules que se encuentran en la imagen
reg VSync_prev=1'b0;//Saber cuando Vsinc pasa de 0 - 1 
	reg Sync=1'b0; // Sincronización para pasar al siguiente pixel (nueva posición X)


	reg [1:0] Fila_Valida_R=1'b0; //Verifica si hay 3 pixeles seguidos del mismo color (Rojo) 
	reg [1:0] Fila_Valida_G=1'b0; //Verifica si hay 3 pixeles seguidos del mismo color (Verde) 
	reg [1:0] Fila_Valida_B=1'b0; //Verifica si hay 3 pixeles seguidos del mismo color (Azul) 

	reg [5:0] Ancho_R=1'b0; //Nos indica cuantos trios de pixeles rojos validos hay por fila
	reg [5:0] Ancho_G=1'b0; //Nos indica cuantos trios de pixeles verdes validos hay por fila
	reg [5:0] Ancho_B=1'b0; //Nos indica cuantos trios de pixeles azules validos hay por fila
	reg [5:0] Ancho_R_Prev=1'b0; //Nos almacena la información de Ancho_R una vez se ha terminado una fila, antes de asignar a Ancho_R a 0 
reg [5:0] Ancho_G_Prev=1'b0; 
reg [5:0] Ancho_B_Prev=1'b0; 
	reg [7:0] Inc_Ancho_R=1'b0; //Nos indica si el ancho de la fila anterior es mayor o menor que a fila actual
reg [7:0] Inc_Ancho_G=1'b0;
reg [7:0] Inc_Ancho_B=1'b0;
	reg [7:0] MID_Ancho_R=1'b0; //Nos indica el ancho mayor de la figura. 
reg [7:0] MID_Ancho_G=1'b0;
reg [7:0] MID_Ancho_B=1'b0;


assign PAddress = XPixel + YPixel*8'd176; //Se guarde en memoría la dirección asignada



	always @(posedge Pclock)begin //Inicia la máquina de estados


		if(Reset==1'b1)begin //Inicializamos los registros en 0 
	WPixel=1'b0;
	Href_prev=1'b0;
	VSync_prev=1'b0;
	XPixel=1'b0;
	YPixel=1'b0;
	Sync=1'b0;
	PixelData=1'b0;
		
	PromedioColorR=1'b0;
	PromedioColorG=1'b0;
	PromedioColorB=1'b0;
	Promedio=1'b0;
	
	Fila_Valida_R=1'b0;
	Fila_Valida_G=1'b0;
	Fila_Valida_B=1'b0;
	
	Ancho_R=1'b0; 
	Ancho_G=1'b0;
	Ancho_B=1'b0;
	Ancho_R_Prev=1'b0; 
	Ancho_G_Prev=1'b0; 
	Ancho_B_Prev=1'b0; 
	Inc_Ancho_R=1'b0;
	Inc_Ancho_G=1'b0;
	Inc_Ancho_B=1'b0;
	MID_Ancho_R=1'b0;
	MID_Ancho_G=1'b0;
	MID_Ancho_B=1'b0;

end
else begin

	if(Vsync==1'b1)begin // Si Vsync esta en 1 no se realiza ninguna acción
		Sync=1'b0;
		WPixel=1'b0;
		XPixel=1'b0;
		YPixel=1'b0;
		
	end
	else if(Href==1'b0 && Href_prev==1'b1)begin //Si se da un cambio en Href entonces iniciamos el procesamiento
		Sync=1'b0;
		WPixel=1'b0;
		XPixel=1'b0;
		YPixel=YPixel+1'b1;
		
		
		
		//Incrementos del contador de Ancho teniendo en cuenta el color
		if(Ancho_R>Ancho_R_Prev)Inc_Ancho_R=Inc_Ancho_R+1'b1;
		else if(Ancho_R<Ancho_R_Prev)Inc_Ancho_R=Inc_Ancho_R-1'b1;
		
		if(Ancho_G>Ancho_G_Prev)Inc_Ancho_G=Inc_Ancho_G+1'b1;
		else if(Ancho_G<Ancho_G_Prev)Inc_Ancho_G=Inc_Ancho_G-1'b1;
		
		if(Ancho_B>Ancho_B_Prev)Inc_Ancho_B=Inc_Ancho_B+1'b1;
		else if(Ancho_B<Ancho_B_Prev)Inc_Ancho_B=Inc_Ancho_B-1'b1;
		
		//Mayor ancho
		if(Inc_Ancho_R>MID_Ancho_R)MID_Ancho_R=Inc_Ancho_R;
		if(Inc_Ancho_G>MID_Ancho_G)MID_Ancho_G=Inc_Ancho_G;
		if(Inc_Ancho_B>MID_Ancho_B)MID_Ancho_B=Inc_Ancho_B;
		//Ancho MID = Ancho Máx
		
		//Reset Ancho cada Hsync dentro del VSync, es decir cada cambio de fila.
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
	
	
	
	
	
	//Si pixel valido y estamos en el recuadro de 100x100 valido entonces:
	if(WPixel==1'b1 && (XPixel<8'd138) && (XPixel>8'd38) && (YPixel<8'd122) && (YPixel>8'd22))begin
	
	
	//Conteo de 3 pixeles de igual proporcion de color seguidos
		if((PixelData[3:0]>PixelData[7:4]) && (PixelData[3:0]>PixelData[11:8]))begin
			Fila_Valida_B=Fila_Valida_B+1'b1;
			Fila_Valida_G=1'b0;
			Fila_Valida_R=1'b0;
		end
		else if((PixelData[7:4]>PixelData[3:0]) && (PixelData[7:4]>PixelData[11:8]))begin
			Fila_Valida_G=Fila_Valida_G+1'b1;
			Fila_Valida_B=1'b0;
			Fila_Valida_R=1'b0;
			
		end
		else if((PixelData[11:8]>PixelData[3:0]) && (PixelData[11:8]>PixelData[7:4]))begin
			Fila_Valida_R=Fila_Valida_R+1'b1;
			Fila_Valida_G=1'b0;
			Fila_Valida_B=1'b0;		
		end
		
		
		
		//Si existen 3 pixeles de proporcion de color seguidos
		if(Fila_Valida_R==2'b11)begin
					Fila_Valida_R=1'b0;
					PromedioColorR=PromedioColorR+1'b1;
					Ancho_R=Ancho_R+1'b1;
		end
		if(Fila_Valida_G==2'b11)begin
					Fila_Valida_G=1'b0;
					PromedioColorG=PromedioColorG+1'b1;
					Ancho_G=Ancho_G+1'b1;
		end
		if(Fila_Valida_B==2'b11)begin
					Fila_Valida_B=1'b0;
					PromedioColorB=PromedioColorB+1'b1;
					Ancho_B=Ancho_B+1'b1;
		end

	end
	
	
	//Final de cada Imagen 
	if(Vsync==1'b1 && VSync_prev==1'b0)begin
		if(PromedioColorR>PromedioColorG && PromedioColorR>PromedioColorB)begin
			Promedio=2'b01;

			if(Inc_Ancho_R<(9'd100+9'd12) && Inc_Ancho_R>(9'd100-9'd12))begin
				if(Inc_Ancho_R<(MID_Ancho_R-9'd12))Forma=2'b10;
				else Forma=2'b01;			   
			end
			else Forma=2'b11;			
			
		end
		else if(PromedioColorG>PromedioColorR && PromedioColorG>PromedioColorB)begin
			Promedio=2'b10;
			
			if(Inc_Ancho_G<(9'd100+9'd12) && Inc_Ancho_G>(9'd100-9'd12))begin
				if(Inc_Ancho_G<(MID_Ancho_G-9'd12))Forma=2'b10;
				else Forma=2'b01;			   
			end
			else Forma=2'b11;

		end
		else if(PromedioColorB>PromedioColorR && PromedioColorB>PromedioColorG)begin
			Promedio=2'b11;
			if(Inc_Ancho_B<(9'd100+9'd12) && Inc_Ancho_B>(9'd100-9'd12))begin
				if(Inc_Ancho_B<(MID_Ancho_B-9'd12))Forma=2'b10;
				else Forma=2'b01;			   
			end
			else Forma=2'b11;

		end
		else begin
			Promedio=2'b00;
			Forma=2'b00;
			
		end
		
		PromedioColorR=1'b0;
		PromedioColorG=1'b0;
		PromedioColorB=1'b0;
		Ancho_R=1'b0; 
		Ancho_G=1'b0;
		Ancho_B=1'b0;
		Ancho_R_Prev=1'b0; 
		Ancho_G_Prev=1'b0; 
		Ancho_B_Prev=1'b0; 
		Inc_Ancho_R=8'd100;
		Inc_Ancho_G=8'd100;
		Inc_Ancho_B=8'd100;
		MID_Ancho_R=1'b0;
		MID_Ancho_G=1'b0;
		MID_Ancho_B=1'b0;
	
	end
	
	
	VSync_prev=Vsync;
	Href_prev=Href;
	
	if ((XPixel>8'd176-1'b1) || (YPixel>8'd144-1'b1)) PixelData=1'b0;


end



end



endmodule
