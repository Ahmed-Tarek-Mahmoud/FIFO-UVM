////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_interface.DUT FIFO_if);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
 
// localparam max_fifo_addr = $clog2(FIFO_DEPTH);
localparam max_fifo_addr = 3;

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		// fix 1 : reset wr_ack on reset
		FIFO_if.wr_ack <= 0;
		// fix 2 : reset overflow on reset
		FIFO_if.overflow <= 0;
		wr_ptr <= 0;
	end
	else if (FIFO_if.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= FIFO_if.data_in;
		FIFO_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		FIFO_if.overflow <= 0; // fix 3 : reset overflow on successful write
	end
	else begin 
		FIFO_if.wr_ack <= 0; 
		if (FIFO_if.full & FIFO_if.wr_en)
			FIFO_if.overflow <= 1;
		else
			FIFO_if.overflow <= 0;
	end
end

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		rd_ptr <= 0;
		// fix 4 : reset underflow on reset
		FIFO_if.underflow <= 0;
	end
	else if (FIFO_if.rd_en && count != 0) begin
		FIFO_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		FIFO_if.underflow <= 0; // fix 5 : reset underflow on successful read
	end
	else begin
		// fix 6 add underflow condition to sequential logic
		if (FIFO_if.empty && FIFO_if.rd_en) begin
			FIFO_if.underflow <= 1;
		end else begin
			FIFO_if.underflow <= 0;
		end
	end
end

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		count <= 0;
	end
	else begin
		if (FIFO_if.wr_en && FIFO_if.rd_en && !FIFO_if.full && !FIFO_if.empty) 
                count <= count; // simultaneous write and read
        else if	(FIFO_if.wr_en && !FIFO_if.full)
	    		count = count + 1;
	    else if (FIFO_if.rd_en && !FIFO_if.empty)
	    		count = count - 1;
		else 
			count = count; // no change in count
	end
end

assign FIFO_if.full = (count == FIFO_DEPTH)? 1 : 0;
assign FIFO_if.empty = (count == 0)? 1 : 0;
// assign FIFO_if.underflow = (FIFO_if.empty && FIFO_if.rd_en)? 1 : 0; // change to sequential logic
assign FIFO_if.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
assign FIFO_if.almostempty = (count == 1)? 1 : 0;


endmodule