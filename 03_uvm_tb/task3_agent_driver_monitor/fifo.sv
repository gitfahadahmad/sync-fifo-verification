timeunit 1ns;
timeprecision 1ns;

module sync_fifo #(parameter depth = 4, parameter data_width = 8)
(fifo_if bus);


localparam int addr_width = $clog2(depth);
logic [addr_width : 0]rd_ptr, wr_ptr; 
logic [data_width-1 : 0]fifo [ 0 : depth-1]; 

//status & error flags
assign bus.full =  (rd_ptr[addr_width] != wr_ptr[addr_width]) & (rd_ptr[addr_width-1 : 0] == wr_ptr[addr_width-1 : 0]);
	 
assign bus.empty =  (rd_ptr[addr_width : 0] == wr_ptr[addr_width : 0]);

assign bus.underflow = (bus.rd_en && bus.empty);
assign bus.overflow = (bus.wr_en && bus.full);


always_ff @(posedge bus.clk or negedge bus.rst_n) begin
if(!bus.rst_n) begin

// resetting the fifo
	for(int i = 0 ; i < depth ; i = i+1) begin
		fifo[i] <= '0;
	end
	
	rd_ptr <= '0;
	wr_ptr <= '0;
	bus.data_out <= '0;
	bus.count <= '0;
end

// Simultaneous read/write allowed when FIFO is neither bus.full nor bus.empty  
else if((bus.wr_en && !bus.full) && (bus.rd_en && !bus.empty)) begin

	fifo[wr_ptr[addr_width-1 : 0]] <= bus.data_in;
	wr_ptr <= wr_ptr+1;

	bus.data_out <= fifo[rd_ptr[addr_width-1 : 0]] ;
	rd_ptr <= rd_ptr+1;
	bus.count <= bus.count;

end

// Write accepted only if FIFO not bus.full
else if(bus.wr_en && !bus.full) begin
	fifo[wr_ptr[addr_width-1 : 0]] <= bus.data_in;
	wr_ptr <= wr_ptr+ 1;
	bus.count <= bus.count + 1;
end


// read accepted only if fifo is not bus.empty

else if(bus.rd_en && !bus.empty) begin
	bus.data_out <= fifo[rd_ptr[addr_width-1 : 0]] ;
	rd_ptr <= rd_ptr+1; 
	bus.count <= bus.count - 1;end



end

endmodule





