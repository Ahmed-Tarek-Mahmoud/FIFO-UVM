package fifo_seq_item_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    parameter FIFO_DEPTH = 8;
    parameter FIFO_WIDTH = 16;
    class fifo_seq_item extends uvm_sequence_item;
        `uvm_object_utils(fifo_seq_item)
        rand bit [FIFO_WIDTH-1:0] data_in;
        rand bit rst_n;
        rand bit wr_en, rd_en;
        bit [FIFO_WIDTH-1:0] data_out;
        bit wr_ack, overflow;
        bit full, empty, almostfull, almostempty, underflow;

        function new(string name = "fifo_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("FIFO_SEQ_ITEM: data_in=%0d, rst_n=%0d, wr_en=%0d, rd_en=%0d, data_out=%0d, wr_ack=%0d, overflow=%0d, full=%0d, empty=%0d, almostfull=%0d, almostempty=%0d, underflow=%0d",
                data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
        endfunction

        // Constraint Blocks
        constraint read_only_c { 
            wr_en == 0; 
            rd_en == 1; 
            rst_n == 1; 
        }

        constraint write_only_c { 
            wr_en == 1; 
            rd_en == 0; 
            rst_n == 1; 
        }

        constraint read_write_c { 
            wr_en dist {0:=30,1:=70};
            rd_en dist {0:=70,1:=30};
            rst_n dist {0:=5,1:=95};
        }


    endclass
endpackage