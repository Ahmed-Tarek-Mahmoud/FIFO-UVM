package fifo_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
    class fifo_config extends uvm_object;
        `uvm_object_utils(fifo_config)

        virtual FIFO_interface fifo_vif; // virtual interface to connect to the DUT
        // constructor
        function new(string name = "fifo_config");
            super.new(name);
        endfunction
    endclass
    
endpackage