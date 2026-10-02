package hello_pkg;

 `include "uvm_macros.svh"
 import uvm_pkg::*;

 class hello_test extends uvm_test;
    `uvm_component_utils(hello_test)

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        `uvm_info ("ID", "Hello World!", UVM_LOW)
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
        `uvm_info("ID", "Check Phase", UVM_HIGH)
    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info("ID", "Report Phase", UVM_LOW)
    endfunction


 endclass

endpackage