`include "uvm_macros.svh"
import uvm_pkg::*;

class tx_monitor extends uvm_monitor;

    
    `uvm_component_utils(tx_monitor)


//build phase
    

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

        virtual fifo_if vif;

//connect phase
    function void build_phase(uvm_phase phase);
        
        super.build_phase(phase);

        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_info("Monitor", "Getting interface Output", UVM_LOW);
    endfunction

//run phase
    task run_phase(uvm_phase phase);


        tx_item tx;

        super.run_phase(phase);

        forever begin
 //       repeat(5) begin
        @(posedge vif.clk);
        
        tx = tx_item::type_id::create("tx");

        if(vif.wr_en || vif.rd_en) begin

            tx.rd_en = vif.rd_en;
            tx.wr_en = vif.wr_en;
            tx.data_in = vif.data_in;
            tx.data_out = vif.data_out;
            tx.overflow = vif.overflow;
            tx.underflow = vif.underflow;
            tx.full = vif.full;
            tx.empty = vif.empty;
            tx.count = vif.count;

            `uvm_info("Monitor", "Data Recieved From Interface ", UVM_LOW );


            end
        end

    endtask



//check phase


//report phase




endclass