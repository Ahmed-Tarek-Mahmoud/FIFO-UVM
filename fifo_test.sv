package fifo_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_config_pkg::*;
import read_only_seq_pkg::*;
import write_only_seq_pkg::*;
import read_write_seq_pkg::*;
import reset_seq_pkg::*;
import fifo_env_pkg::*;

    class fifo_test extends uvm_test;
        `uvm_component_utils(fifo_test)

        // Declare the virtual interface
        fifo_config cfg;

        // sequences declaration
        read_only_seq read_only;
        write_only_seq write_only;
        read_write_seq read_write;
        reset_seq rst_seq;

        // Declare enviroment
        fifo_env env;

        // Constructor
        function new(string name = "fifo_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        // Build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // Create the configuration object
            cfg = fifo_config::type_id::create("cfg", this);
            // Create the sequences
            read_only = read_only_seq::type_id::create("read_only", this);
            write_only = write_only_seq::type_id::create("write_only", this);
            read_write = read_write_seq::type_id::create("read_write", this);
            rst_seq = reset_seq::type_id::create("rst_seq", this);

            // Create the environment
            env = fifo_env::type_id::create("env", this);

            // Get the virtual interface from the configuration database
            if (!uvm_config_db#(virtual FIFO_interface)::get(this, "", "FIFO_IF", cfg.fifo_vif)) begin
                `uvm_fatal("fifoTEST", "Virtual interface not found in the configuration database")
            end
            // set the config object in the DB for later use
            uvm_config_db#(fifo_config)::set(this, "*", "CFG", cfg);
        endfunction

        // Run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            // Start the reset sequence
            `uvm_info("FIFO_TEST", "Starting reset sequence", UVM_MEDIUM)
            rst_seq.start(env.agt.sqr);
            `uvm_info("FIFO_TEST", "Reset sequence completed", UVM_MEDIUM)
            
            // Start the write only sequence
            `uvm_info("FIFO_TEST", "Starting write only sequence", UVM_MEDIUM)
            write_only.start(env.agt.sqr);
            `uvm_info("FIFO_TEST", "Write only sequence completed", UVM_MEDIUM)

            // Start the read only 
            `uvm_info("FIFO_TEST", "Starting read only sequence", UVM_MEDIUM)
            read_only.start(env.agt.sqr);
            `uvm_info("FIFO_TEST", "Read only sequence completed", UVM_MEDIUM)

            // Start the reset sequence
            `uvm_info("FIFO_TEST", "Starting reset sequence", UVM_MEDIUM)
            rst_seq.start(env.agt.sqr);
            `uvm_info("FIFO_TEST", "Reset sequence completed", UVM_MEDIUM)

            // Start the read write sequence
            `uvm_info("FIFO_TEST", "Starting read write sequence", UVM_MEDIUM)
            read_write.start(env.agt.sqr);
            `uvm_info("FIFO_TEST", "Read write sequence completed", UVM_MEDIUM)

            phase.drop_objection(this);
        endtask
        
    endclass    
endpackage