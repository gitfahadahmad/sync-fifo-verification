class generator #(parameter depth = 4, parameter data_width = 8);

transaction tr; // handel to the transaction class
//mailbox
mailbox gen2drv;

int num_of_tr = 5;
int generated_count = 0; // for tracking the count
event gen_done; // event added to check the generator status

function new(mailbox gen2drv);
	this.gen2drv = gen2drv;
endfunction

//generation task
task run();
 generated_count = 0; //initializing the coount to zero for every gen run call

repeat (num_of_tr)	begin
	tr = new(); // new object for each transaction	
	void'(tr.randomize());
	 generated_count++;
	 gen2drv.put(tr);
	 //$display("\nGen Transmitted transaction n0= %0d | ID =%0d ", generated_count, tr.ID);
	 tr.display("Gen");
	end

//trigering the event after completion of no of transactions
$display("\nGen completed all %0d transactions", generated_count);
-> gen_done;

endtask

endclass

