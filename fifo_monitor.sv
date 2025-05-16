package fifo_monitor_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import fifo_seq_item_pkg::*;
    class fifo_monitor extends uvm_monitor;
        `uvm_component_utils(fifo_monitor)

        // Virtual interface to connect to the DUT
        virtual FIFO_interface vif;
        // sequence item to be monitored
        fifo_seq_item item;

        // Analysis port for the monitor
        uvm_analysis_port #(fifo_seq_item) mon_ap;

        // Constructor
        function new(string name = "fifo_monitor", uvm_component parent = null);
            super.new(name, parent);     
        endfunction

        // Build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        // Run phase
        task run_phase(uvm_phase phase);
            forever begin
                item = fifo_seq_item::type_id::create("item"); // Create a new sequence item not to be overwritten
                // Monitor the DUT signals and create a sequence item
                @(negedge vif.clk);
                sample(); // Sample the DUT signals into the sequence item
                // Send the sequence item to the analysis port
                mon_ap.write(item);
                // print the sequence item for debugging
                `uvm_info("run_phase", item.convert2string(), UVM_HIGH);
            end
        endtask

        task sample();
            // Sample the DUT signals into the sequence item
            item.data_in = vif.data_in;
            item.rst_n = vif.rst_n;
            item.wr_en = vif.wr_en;
            item.rd_en = vif.rd_en;
            item.data_out = vif.data_out;
            item.wr_ack = vif.wr_ack;
            item.overflow = vif.overflow;
            item.full = vif.full;
            item.empty = vif.empty;
            item.almostfull = vif.almostfull;
            item.almostempty = vif.almostempty;
            item.underflow = vif.underflow;  
        endtask
    endclass
endpackage