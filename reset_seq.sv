package reset_seq_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_seq_item_pkg::*;
    class reset_seq extends uvm_sequence #(fifo_seq_item);
        `uvm_object_utils(reset_seq)
        
        fifo_seq_item item;
                    
        // Constructor
        function new(string name = "reset_seq");
            super.new(name);
        endfunction

        task body();
            // Create a new sequence item
            item = fifo_seq_item::type_id::create("item");
            start_item(item);
            item.rst_n = 0;
            finish_item(item);
        endtask
    endclass
endpackage