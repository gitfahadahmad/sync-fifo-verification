timeunit 1ns;
timeprecision 1ns;

module top;


import uvm_pkg::*;
import tx_pkg::*;

parameter depth = 4; parameter data_width = 8;
localparam int addr_width = $clog2(depth);


  fifo_if vif();

 sync_fifo  fifo_dut (.bus(vif));



    initial begin 
            vif.clk = 0;
    end


    //  Clock Generation
    always #5 vif.clk = ~vif.clk;


    tx_test t1;

    initial begin

    uvm_config_db#(virtual fifo_if)::set(null, "uvm_test_top.env.agt*", "vif", vif);
    run_test("tx_test");
        
    end
endmodule