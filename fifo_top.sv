import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_test_pkg::*;
module fifo_top ();
    // clock generation
    bit clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // DUT and interface instantiation
    FIFO_interface fifo_if (clk);
    FIFO DUT (fifo_if);

    bind FIFO fifo_sva fifo_sva_inst(
        .rst_n(fifo_if.rst_n),
        .clk(fifo_if.clk),
        .wr_en(fifo_if.wr_en),
        .rd_en(fifo_if.rd_en),
        .data_in(fifo_if.data_in),
        .data_out(fifo_if.data_out),
        .wr_ack(fifo_if.wr_ack),
        .overflow(fifo_if.overflow),
        .full(fifo_if.full),
        .empty(fifo_if.empty),
        .almostfull(fifo_if.almostfull),
        .almostempty(fifo_if.almostempty),
        .underflow(fifo_if.underflow)
    );
    // set the vif in the DB and run the test
    initial begin
        uvm_config_db#(virtual FIFO_interface)::set(null, "uvm_test_top", "FIFO_IF" ,fifo_if);
        run_test("fifo_test");
    end
endmodule