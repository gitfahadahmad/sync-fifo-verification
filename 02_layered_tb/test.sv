class test #(parameter depth = 4, parameter data_width = 8);

    environment env;

    virtual fifo_if vif;

    function new(virtual fifo_if vif);
        this.vif = vif;
        env = new(vif);
    endfunction

    task run();
        $display("====================STARTING FIFO TESTBENCH TEST=======================            ");
        
        env.gen.num_of_tr = 50;
        env.run();

        
        $display("========================TEST EXECUTION COMPLETE========================              ");
       

        $finish;
    endtask

endclass
