`include "uvm_macros.svh"
import uvm_pkg::*;

class tx_agent extends uvm_agent;

    `uvm_component_utils(tx_agent)

    tx_driver drv;
    tx_monitor mon;
    

    uvm_sequencer#(tx_item) sqr; // sequencer used from the uvm base class not extended


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
            drv = tx_driver::type_id::create("drv" , this);
            sqr = new("sqr" , this) ;
            mon = tx_monitor::type_id::create("mon" , this);  
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction




endclass