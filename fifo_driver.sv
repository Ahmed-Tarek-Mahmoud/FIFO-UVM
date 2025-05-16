package fifo_driver_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import fifo_seq_item_pkg::*;

    class fifo_driver extends uvm_driver #(fifo_seq_item);
        `uvm_component_utils(fifo_driver)

        virtual FIFO_interface vif;
        fifo_seq_item item;

        function new(string name = "fifo_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            // Main driver loop
            forever begin
                // Get the next sequence item from the sequencer
                item = fifo_seq_item::type_id::create("item");
                seq_item_port.get_next_item(item);

                // Drive the DUT with the sequence item
                drive_dut();
                // Wait for the DUT to process the item
                @(negedge vif.clk);
                // Indicate that the item has been processed
                seq_item_port.item_done();

            end
        endtask

        task drive_dut();
            vif.wr_en <= item.wr_en;
            vif.rd_en <= item.rd_en;
            vif.data_in <= item.data_in;
            vif.rst_n <= item.rst_n;
        endtask
        
    endclass
endpackage