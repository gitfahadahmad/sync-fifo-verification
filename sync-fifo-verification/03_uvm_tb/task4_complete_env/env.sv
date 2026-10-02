class tx_env extends uvm_env;

    `uvm_component_utils(tx_env)


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    tx_agent agt;
    tx_scoreboard scb;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = tx_agent::type_id::create("agt", this);
        scb = tx_scoreboard::type_id::create("scb", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        agt.mon.ap.connect(scb.sb_ap);

    endfunction



endclass