 `include "uvm_macros.svh"
 import uvm_pkg::*;


class tx_test extends uvm_test;

 //   `uvm_object_utils(tx_test)
    `uvm_component_utils(tx_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    tx_env env;
  

    //build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = tx_env::type_id::create("env", this);
    endfunction


    virtual task run_phase(uvm_phase phase);
        tx_sequence seq;
        seq = tx_sequence::type_id::create("seq");
        phase.raise_objection(this, "Start tx_sequence");
            seq.start(env.agt.sqr);
        phase.drop_objection(this, "End tx_sequence");
    endtask
endclass
