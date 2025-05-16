package fifo_agent_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import fifo_config_pkg::*;
    import fifo_driver_pkg::*;
    import fifo_monitor_pkg::*;
    import fifo_sequencer_pkg::*;
    import fifo_seq_item_pkg::*;

    class fifo_agent extends uvm_agent;;
        `uvm_component_utils(fifo_agent)
        fifo_sequencer sqr;
        fifo_driver driver;
        fifo_monitor mon;
        fifo_config cfg;
        // analysis port for the agent
        uvm_analysis_port #(fifo_seq_item) agt_ap;
        // constructor
        function new(string name = "fifo_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        // build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // get the configuration object from the DB
            if (!uvm_config_db#(fifo_config)::get(this, "", "CFG", cfg)) begin
                `uvm_fatal("fifo_AGENT", "Configuration object not found in the configuration database")
            end
            // create the sequencer, driver and monitor
            sqr = fifo_sequencer::type_id::create("sqr", this);
            driver = fifo_driver::type_id::create("driver", this);
            mon = fifo_monitor::type_id::create("mon", this);
            // create the analysis port
            agt_ap = new("agt_ap", this);
        endfunction

        // connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            // connect the driver to the sequencer
            driver.seq_item_port.connect(sqr.seq_item_export);
            // connect the monitor to the agent analysis port
            mon.mon_ap.connect(agt_ap);
            // connect the virtual interface to the driver and monitor
            driver.vif = cfg.fifo_vif;
            mon.vif = cfg.fifo_vif;
        endfunction
    endclass
endpackage