package fifo_coverage_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import fifo_seq_item_pkg::*;

    class fifo_coverage extends uvm_component;
        `uvm_component_utils(fifo_coverage)
        uvm_analysis_export #(fifo_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(fifo_seq_item) cov_fifo;
        fifo_seq_item seq_item;

        

        covergroup FIFO_cvg_group;
            wr_en_cp : coverpoint seq_item.wr_en {
                option.weight = 0;
            }
            rd_en_cp : coverpoint seq_item.rd_en {
                option.weight = 0;
            }
            overflow_cp : coverpoint seq_item.overflow {
                option.weight = 0;
            }
            underflow_cp : coverpoint seq_item.underflow {
                option.weight = 0;
            }
            full_cp : coverpoint seq_item.full {
                option.weight = 0;
            }
            empty_cp : coverpoint seq_item.empty {
                option.weight = 0;
            }
            almostfull_cp : coverpoint seq_item.almostfull {
                option.weight = 0;
            }
            almostempty_cp : coverpoint seq_item.almostempty {
                option.weight = 0;
            }
            wr_ack_cp : coverpoint seq_item.wr_ack {
                option.weight = 0;
            }
            // cross coverage between wr_en , rd_en and with each output control signal
            //1
            // illegal case : No write and expecting an overflow
            overflow_cross : cross rd_en_cp , wr_en_cp, overflow_cp {
                illegal_bins zero_write_with_overflow = binsof(wr_en_cp) intersect {0} && binsof(overflow_cp) intersect {1};
            }
            //2
            // illegal case : No read and expecting underflow
            underflow_cross : cross rd_en_cp , wr_en_cp, underflow_cp {
                illegal_bins zero_read_with_ack = binsof(rd_en_cp) intersect {0} && binsof(underflow_cp) intersect {1};
            }
            //3
            // illegal case : reading and expecting full
            full_cross : cross rd_en_cp , wr_en_cp, full_cp {
                illegal_bins read_with_full = binsof(rd_en_cp) intersect {1} && binsof(full_cp) intersect {1};
            }
            //4
            empty_cross : cross rd_en_cp , wr_en_cp, empty_cp {}
            //5
            almostfull_cross : cross rd_en_cp , wr_en_cp, almostfull_cp {}
            //6
            almostempty_cross : cross rd_en_cp , wr_en_cp, almostempty_cp {}
            //7
            // illegal case : No write and expecting write acknowledge
            wr_ack_cross : cross rd_en_cp , wr_en_cp, wr_ack_cp {
                illegal_bins zero_write_with_ack = binsof(wr_en_cp) intersect {0} && binsof(wr_ack_cp) intersect {1};
            }
            
        endgroup

        function new(string name = "fifo_coverage", uvm_component parent = null);
            super.new(name, parent);
            FIFO_cvg_group = new;
        endfunction

        // build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_fifo = new("cov_fifo", this);
            cov_export = new("cov_export", this);
        endfunction

        // connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export); // note : open communication channel
        endfunction

        // run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item);     
                FIFO_cvg_group.sample(); 
            end
        endtask
    endclass
endpackage