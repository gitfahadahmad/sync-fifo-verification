`include "uvm_macros.svh"
import uvm_pkg::*;

class tx_item extends uvm_sequence_item;
    `uvm_object_utils(tx_item) //registering in the factory

    function new(string name = "tx_item"); 
        super.new(name);
    endfunction

    rand bit wr_en;
    rand bit rd_en;
    rand bit [7 : 0] data_in;


endclass