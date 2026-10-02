timeunit 1ns;
timeprecision 1ns;
import fifo_pkg::*;

module top;
	 fifo_if bus();
	 
	 sync_fifo  dut ( 
	 
			 .clk(bus.clk),
			 .rst_n(bus.rst_n),
			 .wr_en(bus.wr_en),
			 .rd_en(bus.rd_en),
			 .data_in(bus.data_in),
			 .data_out(bus.data_out),
			 .full(bus.full),
			 .empty(bus.empty),
			 .overflow(bus.overflow),
			 .underflow(bus.underflow),
			 .count(bus.count) 
			 );
	 

    always #5 bus.clk = ~bus.clk;

	initial begin 
	bus.rst_n = 0;
	repeat(2) @(negedge bus.clk);
		bus.rst_n = 1;
	end
	


    test t1;

    initial begin
        wait (bus.rst_n == 1);
        @(posedge bus.clk);
        t1 = new(bus);
        t1.run();
        
        $finish;
    end


    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule
