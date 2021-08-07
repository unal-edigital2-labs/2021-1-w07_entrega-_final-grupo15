module ImBufferv2
#(parameter DATA_WIDTH=4, parameter ADDR_WIDTH=6, parameter imageFILE="Mapa2.mem")
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] read_addr, write_addr,
	input we, read_clock, write_clock,
	output reg [(DATA_WIDTH-1):0] q
);
	
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	
	
	
	initial begin
		$readmemh(imageFILE, ram);
	end
	
	always @ (posedge write_clock)
	begin
		// Write
		if (we)
			ram[write_addr] <= data;
	end
	
	always @ (negedge read_clock)
	begin
		// Read 
		q <= ram[read_addr];
	end
	
endmodule
