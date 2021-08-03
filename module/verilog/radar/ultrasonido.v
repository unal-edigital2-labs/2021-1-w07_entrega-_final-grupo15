`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.11.2020 08:35:50
// Design Name: 
// Module Name: PWM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ultrasonido( 
        input clk,  //Entra la señal de cloc
        input init, //Señal que indica al ultrasonido que mande la señal
        output trigger,
        input eco, //
        output [15:0] tiempo, //para contar hasta 30ms (máx que dura eco)
        output reg done //Registro que informan en que momento la señal de retorno del ultra sonido se ha recibido. 
);

wire clk_1M; //Aquí ya entra el clock de 1M?

reg enable_trigger;
reg tiempo_reset;
reg  [1:0] state;

reg [15:0] period_trigger; //Para prueba
reg [15:0] dutty_trigger;  //Para prueba 



initial begin
        state<=0;
        done<=0;
        period_trigger<=16'd60; //60 micros periodo
        dutty_trigger<=16'd12; // 12 micros ciclo útil
end


always@(posedge clk_1M) 
begin 
 
	case(state)
		0: begin  
		   tiempo_reset<=1; //No hemos iniciado a contar.
                   enable_trigger<=0; // Nuestra señal de disparo no se ha enviado
                   done<=0; // El done se encuentra en 0 ya que la señal de retorno no se ha recibido
			if(init) // Al dar la señal al ultrasonido de que inicie se pasa al estado 1
    	             state<=1;		
		end

		1: begin
		   tiempo_reset<=1; //Aun no estamos contando, tiempo_resete=1 quiere decir
			            //que constantemente estamos re iniciando el contador
                   enable_trigger<=1; //Mandamos nuestra señal de disparo.
                   done<=0; //Done en 0 ya que no hemos recibido la señal de retorno.		        
		
			if(eco)   //Si eco=1 (quiere decir que no se ha detectado la señal de retorno) 
				 // entonces pasamos al estado 2
    	             state<=2;
  		end

		2: begin
			tiempo_reset<=0; //El conteo inicia ya que se envió la señal de disparo 
			                 // (debe ir y volver para determinar la distancia)
                   enable_trigger<=0;  //El triger está en 0 ya que no se envia la señal nuevamente.
                   done<=0; 

			if(!eco)  //Una vez eco=0 quiere decir que la señal que se envió ha retornado
    	             state<=3;
  		end  

        3: begin 
		           tiempo_reset<=0; //Aún no se detiene el conteo sin embargo done es 1 ya que la señal ya se recibió.
                   enable_trigger<=0; 	
                   done<=1;
                   
		if (init==0) // Para volver a usar el ultrasonido, se asigna un 0 a la señal de init. 
                   state<=0;
        end


	endcase
end 



clk_div #(50) clk1_1M(.clk(clk),.clk_out(clk_1M)); 
counter counter1(.clk(clk_1M), .count(tiempo), .reset(tiempo_reset));
pwm trigger1(.clk(clk) ,  .enable(enable_trigger),  .dutty(dutty_trigger),  .period(period_trigger), .pwm_out(trigger) );

endmodule 

