class monitor #(parameter depth =4, parameter data_width= 8);

 virtual fifo_if vif;

 mailbox mon2scb;

 int mon_count =-1;
 
 
 function new(virtual fifo_if vif, mailbox mon2scb);
 	this.vif = vif;
 	this.mon2scb = mon2scb;
 endfunction
 
 task run();
   transaction tr;
   forever begin
    @(negedge vif.clk);
//    allocating the fresh transactionn container
    tr = new();
    
    //copying the signals from the interface
    
    tr.wr_en = vif.wr_en;
    tr.rd_en = vif.rd_en;
    tr.data_in = vif.data_in; 

    tr.data_out = vif.data_out;
    tr.overflow = vif.overflow;
    tr.underflow =  vif.underflow;
    tr.full = vif.full;
    tr.empty = vif.empty;
    tr.count = vif.count;
    
    mon2scb.put(tr);
    mon_count ++;
    
    $display("\n Time = [%0t] ns | Monitor sampled cycle  \t= %0d | wr_en = %0b | rd_en = %0b | data_in = %0d | data_out = %0d | full = %0b | empty = %0b | overflow = %0b | underflow = %0b | count = %0d ",$time, mon_count, tr.wr_en, tr.rd_en, tr.data_in, tr.data_out, tr.full, tr.empty, tr.overflow, tr.underflow, tr.count);
    
  end
 endtask
endclass


