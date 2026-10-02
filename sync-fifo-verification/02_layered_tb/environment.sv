class environment #(parameter depth = 4, parameter data_width = 8);

    generator  gen;
    driver    drv;
    monitor    mon;
    scoreboard scb;
    
    mailbox  gen2drv;
    mailbox mon2scb;    
    
    virtual fifo_if vif;
    
    function new(virtual fifo_if vif);
    
     this.vif = vif;
    
     gen2drv = new();
     mon2scb = new();
    
     gen = new(gen2drv);
     drv = new(vif, gen2drv);
     mon = new(vif, mon2scb);
     scb = new(mon2scb);
    
    endfunction
    
    // Reset Task
    task pre_test();
        $display("=========================Environment Resetting DUT....====================================");
        drv.reset();
        $display("=============================Environment Reset Complete....=======================================");
    endtask
    
    
    // Main Test Execution Task
    task test();
        $display("===================================Environment Starting Test================================");
        fork
            gen.run();
            drv.run();
      
            mon.run();
            scb.run();
        join_none
    endtask
    
    
    task post_test();
        // Wait for Generator to emit all transactions
        wait (gen.gen_done.triggered);
     //   @(gen.gen_done);

        // Allow Driver, Monitor, & Scoreboard to drain remaining pipelines
        //repeat (10) @(vif.cb_driver);
        #(gen.num_of_tr * 10 +10);
        //#100;

        // Print final verification report
      scb.report();
        $display("==============================Environment Test Execution Finished.========================================");
    endtask
    
    task run();
        pre_test();
        
        test();
       
        post_test();
    endtask
    
endclass
