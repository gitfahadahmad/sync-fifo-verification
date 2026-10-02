`include "uvm_macros.svh"
import uvm_pkg::*;


class tx_driver extends uvm_driver #(tx_item);

    `uvm_component_utils(tx_driver)

        virtual fifo_if vif;



    //constructor Build phase
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_error("Driver Error", "Interface not found")

    endfunction

    // connect phase


    //run phase

    virtual task run_phase(uvm_phase phase);
        tx_item tx;

        forever begin
            seq_item_port.get_next_item(tx);

            transfer(tx);
            `uvm_info("DRIVER",$sformatf("%s",tx.hello),UVM_LOW);

            seq_item_port.item_done();


        end

    endtask


    virtual task transfer(tx_item tr);

        @(posedge vif.clk);
        
        vif.wr_en <= tr.wr_en;
        vif.rd_en <= tr.rd_en;
        vif.data_in <= tr.data_in;
        `uvm_info("Driver", "Hello Interface ", UVM_LOW );
 
    endtask


    //check phase



    //report phase


endclass