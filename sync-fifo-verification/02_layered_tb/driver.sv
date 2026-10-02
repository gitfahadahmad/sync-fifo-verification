class driver#(parameter depth =4, parameter data_width= 8);
 
 virtual fifo_if vif;
 
 mailbox gen2drv;
 
 transaction tr; 
 int transaction_count = 0;

 function new(virtual fifo_if vif, mailbox gen2drv);
  this.vif = vif;
  this.gen2drv = gen2drv;
 endfunction
 
 task reset();
  	$display(" ");
  	$display("Driver: Starting reset");

  	vif.wr_en <= 1'b0; //reset
 	vif.rd_en <= 1'b0; //reset
 	
 	repeat(2) @(posedge vif.clk);//holding reset for 2 clock cycles
 	//vif.rst_n = 1'b1;
 	//vif.rst_n <= 1'b1; //deasserting reset
 	$display("Driver Reset De-Asserted");
 endtask
 
 task run();
 forever begin
 	gen2drv.get(tr); //fetching the transaction value
 	@(posedge vif.clk); //sync with cb edge
 	
 	//sending control signals

 	vif.wr_en <= tr.wr_en;
 	vif.rd_en <= tr.rd_en;
 	vif.data_in <= tr.data_in;
 	
// 	@(vif.clk);
 	
 	//clearing the control signals
// 	vif.wr_en <= 1'b0;
// 	vif.rd_en <= 1'b0;
 	
 	transaction_count++;
 //	$display("Time = [%0t] ns | Driver executed Transaction_no \t= %0d | wr_en = %0b | rd_en = %0b | data_in = %0d",$time, transaction_count, tr.wr_en, tr.rd_en, tr.data_in  );
 	
      end
      
  endtask
endclass

