package hello_pkg;

 `include "uvm_macros.svh"
 import uvm_pkg::*;


class tx_item extends uvm_sequence_item;

    `uvm_object_utils(tx_item)

    function new(string name="tx_item");
        super.new(name);
    endfunction

    rand bit wr_en;
    rand bit rd_en;
    rand bit [7 : 0] data_in;

endclass


class tx_sequence extends uvm_sequence#(tx_item);
    `uvm_object_utils(tx_sequence)
       function new(string name="tx_sequence");
        super.new(name);
    endfunction

    virtual task body();

        repeat(5) begin
            req = tx_item::type_id::create("rqq");
            'void(req.randomize());
             `uvm_info ("ID", $sformatf("data_in = %0d | write_en = %0d | read_en = %0d",req.data_in,req.write_en,req.read_en), UVM_LOW)

        end

    endtask

endclass


 class hello_test extends uvm_test;
    `uvm_component_utils(hello_test)
    tx_sequence sq;


    function new(string name, uvm_component parent);
            super.new(name, parent);
            sq.start(null);
    endfunction

    virtual task run_phase(uvm_phase phase);
        `uvm_info ("ID", "Hello World!", UVM_LOW)
        sq = tx_sequence::type_id::create("sq");
    endtask

    virtual function void build_phase(uvm_phase phase);
        `uvm_info("ID", "Build Phase", UVM_HIGH)
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        `uvm_info("ID", "Connect Phase", UVM_LOW)
    endfunction

    virtual function  void end_of_elaboration();
        `uvm_info("ID", "End of Elaboration Phase", UVM_LOW)
    endfunction
    
    virtual function void start_of_simulation();
        `uvm_info("ID", "Start of Simulation Phase", UVM_LOW)
    endfunction

    virtual function void check_phase(uvm_phase phase);
        `uvm_info("ID", "Check Phase", UVM_LOW)
    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info("ID", "Report Phase", UVM_LOW)
    endfunction


 endclass

endpackage