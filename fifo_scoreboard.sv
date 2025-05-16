package fifo_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import fifo_seq_item_pkg::*;
    class fifo_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(fifo_scoreboard)

        uvm_analysis_export #(fifo_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(fifo_seq_item) sb_fifo;
        fifo_seq_item seq_item;

        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;

        bit [FIFO_WIDTH-1:0] data_out_ref;
        bit wr_ack_ref, overflow_ref;
        bit full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
        bit [FIFO_WIDTH-1:0] mem [$];
        int count = 0;
        

        int error_count = 0;
        int correct_count = 0;


        // Constructor
        function new(string name = "fifo_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        // build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_fifo = new("sb_fifo", this);
            sb_export = new("sb_export", this);
        endfunction

        // connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export); // note : open communication channel
            // export to export connection as both are passive
        endfunction
        
        // run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item); 
                golden_model(seq_item);
                if (seq_item.data_out !== data_out_ref) begin
                    `uvm_error("fifo_SCOREBOARD", $sformatf("Data mismatch: expected %0d, got %0d", data_out_ref, seq_item.data_out));
                    error_count++;
                end else begin
                    correct_count++;
                end
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("fifo_SCOREBOARD", $sformatf("Correct: %0d, Errors: %0d", correct_count, error_count), UVM_MEDIUM);
        endfunction
        

    // golden model
    task golden_model(fifo_seq_item seq_item);
        // handle write operation
        if (!seq_item.rst_n) begin
            mem.delete(); // clear the memory on reset
            overflow_ref = 0;
            wr_ack_ref = 0;
        end
        else if (seq_item.wr_en && !full_ref) begin
            mem.push_back(seq_item.data_in); // push data into the memory
            wr_ack_ref = 1; // acknowledge the write
            overflow_ref = 0; // reset overflow flag
        end
        else begin
            wr_ack_ref = 0; // no write acknowledge
            if (full_ref && seq_item.wr_en) begin
                overflow_ref = 1; // set overflow flag if full and write enabled
            end else begin
                overflow_ref = 0; // reset overflow flag
            end
        end

        // handle read operation
        if (!seq_item.rst_n) begin
            mem.delete(); // clear the memory on reset
            underflow_ref = 0; // reset underflow flag
        end
        else if (seq_item.rd_en && !empty_ref) begin
            data_out_ref = mem.pop_front(); // pop data from the memory
            underflow_ref = 0; // reset underflow flag
        end
        else begin
            if (empty_ref && seq_item.rd_en) begin
                underflow_ref = 1; // set underflow flag if empty and read enabled
            end else begin
                underflow_ref = 0; // reset underflow flag
            end
        end

        // update the count
        if (!seq_item.rst_n) begin
            count = 0; // reset count on reset
        end
        else if (seq_item.wr_en && seq_item.rd_en && !full_ref && !empty_ref) begin
            count = count; // simultaneous write and read, no change in count
        end
        else if (seq_item.wr_en && !full_ref) begin
            count = count + 1; // increment count on write
        end
        else if (seq_item.rd_en && !empty_ref) begin
            count = count - 1; // decrement count on read
        end
        else begin
            count = count; // no change in count
        end

        // update the status flags
        full_ref = (count == FIFO_DEPTH) ? 1 : 0;
        empty_ref = (count == 0) ? 1 : 0;
        almostfull_ref = (count == FIFO_DEPTH-1) ? 1 : 0;
        almostempty_ref = (count == 1) ? 1 : 0;
    endtask

    endclass

    
endpackage