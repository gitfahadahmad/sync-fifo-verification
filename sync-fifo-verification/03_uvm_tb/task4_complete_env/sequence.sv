 `include "uvm_macros.svh"
 import uvm_pkg::*;


class tx_sequence extends uvm_sequence#(tx_item);
    `uvm_object_utils(tx_sequence)


    function new(string name="tx_sequence");
        super.new(name);
    endfunction

    virtual task body();
        
        tx_item tx;

        repeat(100) begin
            tx = tx_item::type_id::create("tx");
            start_item(tx);
            if(!tx.randomize()) `uvm_fatal("ID" ,"Randomization Failed");
            finish_item(tx);
        end

    endtask

endclass

