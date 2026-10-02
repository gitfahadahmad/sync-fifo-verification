module sync_fifo #(parameter depth = 16, parameter data_width = 8)(
input logic clk, rst_n, rd_en, wr_en, 
input logic [data_width-1 : 0]data_in,
output logic [data_width-1:0] data_out,
output logic overflow, underflow, full, empty,
output logic [$clog2(depth)-1 : 0]count
);

logic [$clog2(depth) : 0]rd_ptr, wr_ptr; 

logic [data_width-1 : 0]fifo [ 0 : depth-1]; 




always_ff @(posedge clk or negedge rst_n) begin
if(!rst_n) begin

// resetting the fifo
	for(int i = 0 ; i < depth-1 ; i = i+1) begin
		fifo[i] <= '0;
	end
	
	rd_ptr <= '0;
	wr_ptr <= '0;
	data_out <= '0;
	count <= '0;
end

// Write accepted only if FIFO not full
else if(wr_en && !full) begin
	fifo[wr_ptr[$clog2(depth)-1 : 0]] <= data_in;
	wr_ptr <= wr_ptr+ 1;
	count <= count + 1;
end


// read accepted only if fifo is not empty

else if(rd_en && !empty) begin
	data_out <= fifo[rd_ptr[$clog2(depth)-1 : 0]] ;
	rd_ptr <= rd_ptr+1; 
	count <= count - 1;end


// Simultaneous read/write allowed when FIFO is neither full nor empty
else if((wr_en && !full) && (rd_en && !empty)) begin

	fifo[wr_ptr[$clog2(depth)-1 : 0]] <= data_in;
	wr_ptr <= wr_ptr+1;

	data_out <= fifo[rd_ptr[$clog2(depth)-1 : 0]] ;
	rd_ptr <= rd_ptr+1;

end
end

assign full =  (rd_ptr[$clog2(depth)] != wr_ptr[$clog2(depth)]) & (rd_ptr[$clog2(depth)-1 : 0] == wr_ptr[$clog2(depth)-1 : 0]);
	 
assign empty =  (rd_ptr[$clog2(depth) : 0] == wr_ptr[$clog2(depth) : 0]);

assign underflow = (rd_en && empty);
assign overflow = (wr_en && full);


endmodule





