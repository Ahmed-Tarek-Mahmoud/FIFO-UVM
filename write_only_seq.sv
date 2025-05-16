package write_only_seq_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_seq_item_pkg::*;
    class write_only_seq extends uvm_sequence #(fifo_seq_item);
        `uvm_object_utils(write_only_seq)
        
        fifo_seq_item item;
                    
        // Constructor
        function new(string name = "write_only_seq");
            super.new(name);
        endfunction

        task body();
            // Create a new sequence item
            item = fifo_seq_item::type_id::create("item");
            item.read_only_c.constraint_mode(0);
            item.write_only_c.constraint_mode(1);
            item.read_write_c.constraint_mode(0);
            repeat (9) begin
                start_item(item);
                assert(item.randomize());
                finish_item(item);
            end
        endtask
    endclass
endpackage