timeunit 1ns;
timeprecision 1ns;

module sync_fifo #(
  parameter int DATA_WIDTH = 8,
  parameter int DEPTH      = 4,
  parameter int ADDR_WIDTH = $clog2(DEPTH)
)(
  input  logic                  clk,
  input  logic                  rst_n,
  input  logic                  wr_en,
  input  logic                  rd_en,
  input  logic [DATA_WIDTH-1:0] data_in,
  output logic [DATA_WIDTH-1:0] data_out,
  output logic                  full,
  output logic                  empty,
  output logic                  overflow,
  output logic                  underflow,
  output logic [ADDR_WIDTH:0]   count
);

  logic [DATA_WIDTH-1:0] mem [DEPTH];
  logic [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;

  
  assign full  = (count >= (DEPTH[ADDR_WIDTH:0]));
  assign empty = (count == '0);
  assign overflow  = wr_en & full;
  assign underflow = rd_en & empty;

  wire rd_acc = rd_en & ~empty;
  wire wr_acc = wr_en & (~full | rd_acc);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_ptr    <= '0;
      rd_ptr    <= '0;
      count     <= '0;
      data_out  <= '0;

    end
    else begin
      //overflow  <= wr_en & full;
      //underflow <= rd_en & empty;

      if (wr_acc) begin
        mem[wr_ptr] <= data_in;
        wr_ptr <= (wr_ptr == DEPTH-1) ? '0 : wr_ptr + 1'b1;

        //wr_ptr      <= wr_ptr + 1'b1;
      end
      if (rd_acc) begin
        data_out <= mem[rd_ptr];
        rd_ptr <= (rd_ptr == DEPTH-1) ? '0 : rd_ptr + 1'b1;
        //rd_ptr   <= rd_ptr + 1'b1;
      end

      unique case ({wr_acc, rd_acc})
        2'b10:   count <= count + 1'b1;
        2'b01:   count <= count - 1'b1;
        default: count <= count;
      endcase
    end
  end

endmodule
