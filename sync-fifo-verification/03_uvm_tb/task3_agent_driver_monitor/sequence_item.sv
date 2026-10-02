`include "uvm_macros.svh"
import uvm_pkg::*;

class tx_item extends uvm_sequence_item;
    `uvm_object_utils(tx_item) //registering in the factory(uvm_object_macros)

    function new(string name = "tx_item"); 
        super.new(name);
    endfunction

    rand bit wr_en;
    rand bit rd_en;
    rand bit [7 : 0] data_in;
    bit [7:0] data_out;
    bit overflow, underflow, full, empty;
    bit [3 : 0]count;
    string hello = "Sequence_item_generated";

endclass