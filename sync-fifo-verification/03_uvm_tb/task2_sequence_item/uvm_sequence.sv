 `include "uvm_macros.svh"
 import uvm_pkg::*;


class tx_sequence extends uvm_sequence #(tx_item);
    `uvm_object_utils(tx_sequence)

//build
    function new(string name = "tx_sequence");
        super.new(name);
    endfunction
// connect not avalable

//run phase
    virtual task body();
        tx_item tx;

        repeat(5) begin
            tx = tx_item::type_id::create("tx"); // factory creating for the tx instead of new
            start_item(tx); // wait for driver to be ready
            if (!tx.randomize()) `uvm_fatal("randomization failed");
            finish_item(tx); //sends and wait for response from the driver


        end


    endtask
//check phase


//report phase



endclass