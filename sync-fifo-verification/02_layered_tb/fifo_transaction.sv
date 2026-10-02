class transaction #(parameter depth = 4, parameter data_width = 8);


//randomizable variables
rand bit wr_en;
rand bit rd_en;
rand bit [data_width-1 : 0] data_in;


localparam int addr_width = $clog2(depth);

bit  [data_width-1:0] data_out;
bit  overflow, underflow, full, empty;
bit  [addr_width : 0]count;

//instance tracking
static int count_id = 0;
int   ID;


//One or more legal randomization constraints, including a purposeful distribution across idle,
//read, write and simultaneous activity.

constraint c_data_in { data_in inside {[0:100]}; data_in % 2 == 0;}
//constraint c_states  { {rd_en, wr_en}  dist {2'b00:=0, 2'b01:=50, 2'b10:=50, 2'b11:= 0};} // idle read and write 00, write 01, read 10, simultaneous
constraint c_states {wr_en != rd_en;}


//constructor
function new();// constructor
	count_id++;
	this.ID = count_id;
endfunction

//A display or print method producing a readable one-line transaction record.

function void display(string name = "Transaction");
$display("\n[%0s] | Time = [%0t] ns |ID = %0d | wr_en = %0b | rd_en = %0b | data_in = %0d | data_out = %0d | full = %0b | empty = %0b | overflow = %0b | underflow = %0b | count = %0d ", name,$time, ID, wr_en, rd_en, data_in, data_out, full, empty, overflow, underflow, count);
endfunction


// A copy method that creates an independent object.
function void copy(transaction #(depth, data_width) tr); 
	if(tr == null) begin
	 $error("copy failed, transaction handel 'tr' is null");
	 return;
	end  

	tr.ID = 	this.ID;
	tr.wr_en = 	this.wr_en;
	tr.rd_en = 	this.rd_en;
	tr.data_in = 	this.data_in;
	tr.data_out = 	this.data_out;
	tr.overflow = 	this.overflow;
	tr.underflow = 	this.underflow;
	tr.full = 	this.full;
	tr.empty = 	this.empty;
	tr.count = 	this.count;

endfunction

/*
// clone method that creates an independent object.
function transaction #(depth, data_width) clone();
 transaction #(depth, data_width) tr_clone;
 tr_clone = new();
 this.copy(tr_clone);
 return tr_clone;
endfunction */
endclass


