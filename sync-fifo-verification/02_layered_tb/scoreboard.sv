class scoreboard #(parameter depth = 4, parameter data_width = 8);

mailbox mon2scb;

logic [data_width-1:0] ref_fifo[$]; // dynamic queue allocation for reference model

// ref model flags
bit expected_full;
bit expected_empty;
bit expected_overflow;
bit expected_underflow;
int expected_count;

// test count
int pass_count = 0;
int fail_count = 0;

function new(mailbox mon2scb);
   this.mon2scb = mon2scb;
endfunction

task run();
 transaction tr;
 bit check_read = 0;
 logic [data_width-1:0] expected_read_data;
 bit trans_pass;

 forever begin
	 mon2scb.get(tr);
	 trans_pass = 1;
	 //tr.display();

	 // Checking DUT outputs against CURRENT expected state (before applying new inputs)
	 expected_count = ref_fifo.size();
	 expected_empty = (expected_count == 0);
	 expected_full = (expected_count == depth); 

	 expected_overflow = tr.wr_en && expected_full;
	 expected_underflow = tr.rd_en && expected_empty;

	 trans_pass &= check_flag("Full", tr.full, expected_full, tr.ID);
	 trans_pass  &=  check_flag("Empty", tr.empty, expected_empty, tr.ID);
	 trans_pass &= check_flag("Overflow", tr.overflow, expected_overflow, tr.ID);
	 trans_pass &= check_flag("Underflow", tr.underflow, expected_underflow, tr.ID);
	 trans_pass &= check_count(tr.count, expected_count, tr.ID); 

	 // Checking read data requested from the PREVIOUS cycle
	 if (check_read) begin
	 	trans_pass &= check_read_data(tr.data_out, expected_read_data, tr.ID);
	 	check_read = 0; // Reset flag after checking
	 end
	 
	if(trans_pass) begin
		pass_count++;
	end else begin
		fail_count++;
	end
	 // Update Reference Model for the NEXT cycle
	 if (tr.wr_en && !expected_full) begin
	 	ref_fifo.push_back(tr.data_in);
	 end

	 if (tr.rd_en && !expected_empty) begin
		 expected_read_data = ref_fifo.pop_front();
		 check_read = 1; // Set flag to verify data_out in the next cycle
	 end
 end
endtask

// Helper checking functions
function  check_read_data(logic [data_width-1:0] actual, logic [data_width-1:0] expected, int ID);
	if (actual === expected) begin
		$display("\n Time = [%0t] ns | [SCOREBOARD PASS] Trans ID #%0d | Read Data Match: DUT=%0d | REF=%0d",$time, ID, actual, expected);
		return 1;
	end else begin
		$display("\n Time = [%0t] | [SCOREBOARD FAIL] Trans ID #%0d | Read Data Mismatch: DUT=%0d | REF=%0d", $time, ID, actual, expected);
		return 0;
	end
endfunction

// Helper Check Method: Flags
function  check_flag(string flag_name, bit actual, bit expected, int ID);
	if (actual !== expected) begin
		$display("\n Time = [%0t] | SCOREBOARD FAIL | Trans ID #%0d | %0s Mismatch: DUT=%0b | REF=%0b",$time ,ID, flag_name, actual, expected);
		return 0;
	end else begin
		return 1;
	end
endfunction

// Helper Check Method: Count
function  check_count(int actual, int expected, int ID);
	if (actual !== expected) begin
		$display("\n Time = [%0t] | SCOREBOARD FAIL | Trans ID #%0d | COUNT Mismatch: DUT=%0d | REF=%0d",$time,  ID, actual, expected);
		return 0;
	end else begin
		return 1;
	end
endfunction

// Report
function void report();
	$display(" ");
  	$display("===============================Final Testing Report====================================== ");
	$display(" Total passed checks = %0d", pass_count);
	$display(" ");
	$display(" Total failed checks = %0d", fail_count);
	if (fail_count == 0 && pass_count > 0)
		$display("=================== TEST PASSED SUCCESSFULLY ==================");
	else
		$display("============= TEST FAILED===================");

endfunction

endclass



