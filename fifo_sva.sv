module fifo_sva ( rst_n , clk, wr_en, rd_en, data_in, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow );

input rst_n, clk, wr_en, rd_en;
input [DUT.FIFO_WIDTH-1:0] data_in;
input [DUT.FIFO_WIDTH-1:0] data_out;
input wr_ack, overflow, full, empty, almostfull, almostempty, underflow;

///////////////////////////////////////////////////////////////
// Assertions
///////////////////////////////////////////////////////////////

// Reset behavior
always_comb begin
	if(!rst_n) 
	a_reset : assert final (!DUT.rd_ptr && !DUT.wr_ptr && DUT.count == 0) 
				else $error("Reset failed: rd_ptr = %0d, wr_ptr = %0d, count = %0d", DUT.rd_ptr, DUT.wr_ptr, DUT.count);
end

// write acknowledge
property wr_ack_check;
	@(posedge clk) disable iff(!rst_n) 
	wr_en && !full |=> (wr_ack == 1);
endproperty

// overflow check
property overflow_check;
	@(posedge clk) disable iff(!rst_n) 
	wr_en && full |=> (overflow == 1);
endproperty

// underflow check
property underflow_check;
	@(posedge clk) disable iff(!rst_n) 
	rd_en && empty |=> (underflow == 1);
endproperty

// Empty check
property empty_check;
	@(posedge clk) 
	DUT.count == 0 |-> (empty == 1);
endproperty

// Full check
property full_check;
	@(posedge clk) disable iff(!rst_n)
	(DUT.count == DUT.FIFO_DEPTH) |-> (full == 1);
endproperty

// Almost full check
property almostfull_check;
	@(posedge clk) disable iff(!rst_n)
	(DUT.count == DUT.FIFO_DEPTH-1) |-> (almostfull == 1);
endproperty

// Almost empty check
property almostempty_check;
	@(posedge clk) disable iff(!rst_n)
	(DUT.count == 1) |-> (almostempty == 1);
endproperty

// pointers wraparound check
property rd_ptr_wrap_check;
	@(posedge clk) disable iff(!rst_n)
	(DUT.rd_ptr == DUT.FIFO_DEPTH-1 && rd_en && !empty) |=> (DUT.rd_ptr == 0);
endproperty

property wr_ptr_wrap_check;
	@(posedge clk) disable iff(!rst_n)
	(DUT.wr_ptr == DUT.FIFO_DEPTH-1 && wr_en && !full) |=> (DUT.wr_ptr == 0);
endproperty

property counter_check_up;
	@(posedge clk) disable iff(!rst_n)
	(wr_en && !full && !rd_en) |=> (DUT.count == $past(DUT.count) + 1);
endproperty

property counter_check_down;
	@(posedge clk) disable iff(!rst_n)
	(rd_en && !empty && !wr_en) |=> (DUT.count == $past(DUT.count) - 1);
endproperty

property count_wrap_check;
	@(posedge clk)
	($past(DUT.count , 2) == DUT.FIFO_DEPTH && !$past(rst_n)) |-> (DUT.count == 0);
endproperty

// pointer threshold check
property ptrs_threshold;
    @(posedge clk) DUT.rd_ptr < DUT.FIFO_DEPTH && DUT.wr_ptr < DUT.FIFO_DEPTH;
endproperty

assert property (wr_ack_check);
assert property (overflow_check);
assert property (underflow_check);
assert property (empty_check);
assert property (full_check);
assert property (almostfull_check);
assert property (almostempty_check);
ptr_wrap_1 : assert property (rd_ptr_wrap_check);
ptr_wrap_2 : assert property (wr_ptr_wrap_check);
assert property (counter_check_up);
assert property (counter_check_down);
cnt_wrap_check : assert property (count_wrap_check);
ptr_threshold : assert property (ptrs_threshold);

cover property (wr_ack_check);
cover property (overflow_check);
cover property (underflow_check);
cover property (empty_check);
cover property (full_check);
cover property (almostfull_check);
cover property (almostempty_check);
cover property (rd_ptr_wrap_check);
cover property (wr_ptr_wrap_check);
cover property (counter_check_up);
cover property (counter_check_down);
cover property (count_wrap_check);
cover property (ptrs_threshold);
    
endmodule