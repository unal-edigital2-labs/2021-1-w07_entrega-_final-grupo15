module ImBuffer
#(parameter DATA_WIDTH=12, parameter ADDR_WIDTH=15, parameter imageFILE="Im.mem")
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
		ram[15'b111111111111111]=12'b00000000;
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

