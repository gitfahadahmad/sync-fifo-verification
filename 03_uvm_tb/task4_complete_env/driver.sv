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

        // Ensure interface is zeroed out before transactions begin
        // vif.wr_en <= 0;
        // vif.rd_en <= 0;
        // vif.data_in <= 0;

        wait(vif.rst_n == 1);
        @(posedge vif.clk); 

        forever begin
            seq_item_port.get_next_item(tx);

            transfer(tx);

            `uvm_info("DRIVER", "Transaction driven to interface", UVM_LOW);

            seq_item_port.item_done();
        end
    endtask


    virtual task transfer(tx_item tr);

        @(negedge vif.clk);
        
        vif.wr_en <= tr.wr_en;
        vif.rd_en <= tr.rd_en;
        vif.data_in <= tr.data_in;

        `uvm_info("Driver", "Hello Interface ", UVM_LOW );
        @(posedge vif.clk);


    endtask


    //check phase



    //report phase


endclass

// Inside tx_driver.sv
