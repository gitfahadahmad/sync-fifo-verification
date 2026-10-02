class tx_env extends uvm_env;

    `uvm_component_utils(tx_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    tx_agent agt;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = tx_agent::type_id::create("agt", this);

    endfunction

endclass