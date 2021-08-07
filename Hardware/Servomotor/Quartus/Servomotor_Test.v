module Servomotor_Test(
	input Clock,
	input [2:0] Switches,
	output servomotor
);

reg [11:0] ciclo=0;

always @(posedge Clock)begin 

	if(Switches[0]==1'b1)ciclo=12'd99;
	else if(Switches[1]==1'b1)ciclo=12'd299;
	else if(Switches[2]==1'b1)ciclo=12'd499;

end


Servomotor xD(Clock, 16'd249, ciclo, servomotor,1'b0);



endmodule
