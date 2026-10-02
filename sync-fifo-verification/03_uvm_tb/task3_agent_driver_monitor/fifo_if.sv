timeunit 1ns;
timeprecision 1ns;

interface fifo_if #(parameter depth = 4, parameter data_width = 8);

localparam int addr_width = $clog2(depth);

//declaration of the direction less signals
bit clk;
logic rst_n;
logic rd_en, wr_en; 
logic [data_width-1 : 0]data_in;
logic [data_width-1:0] data_out;
logic overflow, underflow, full, empty;
logic [addr_width : 0]count;


//Create a driver clocking block that applies inputs away from the DUT sampling edge.

clocking cb_driver @(posedge clk);
 default input #1ns output #2ns;
 output clk, rst_n, rd_en, wr_en, data_in;
endclocking

//  Create a monitor clocking block that samples after DUT nonblocking assignments have updated.
clocking cb_monitor @(negedge clk);
default input #1ns output #2ns;
 input rd_en, wr_en, data_in;
 input data_out, overflow, underflow, full, empty, count;
endclocking

modport driver (clocking cb_driver);
modport monitor (clocking cb_monitor);



endinterface : fifo_if



