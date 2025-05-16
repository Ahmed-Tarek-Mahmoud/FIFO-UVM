# FIFO UVM Verification Project

This repository contains a complete SystemVerilog UVM (Universal Verification Methodology) testbench for verifying a parameterized FIFO (First-In-First-Out) design. The project includes the RTL design, UVM environment, sequences, scoreboard, coverage, and formal assertions.

## Directory Structure

```
.
├── FIFO.sv                # RTL FIFO design
├── FIFO_interface.sv      # SystemVerilog interface for DUT
├── fifo_top.sv            # Top-level testbench module
├── fifo_sva.sv            # SystemVerilog Assertions for FIFO
├── fifo_config.sv         # UVM configuration object
├── fifo_seq_item.sv       # UVM sequence item
├── fifo_sequencer.sv      # UVM sequencer
├── fifo_driver.sv         # UVM driver
├── fifo_monitor.sv        # UVM monitor
├── fifo_agent.sv          # UVM agent
├── fifo_scoreboard.sv     # UVM scoreboard (reference model)
├── fifo_coverage.sv       # UVM coverage collector
├── fifo_env.sv            # UVM environment
├── fifo_test.sv           # UVM test
├── read_only_seq.sv       # UVM sequence: read only
├── write_only_seq.sv      # UVM sequence: write only
├── read_write_seq.sv      # UVM sequence: mixed read/write
├── reset_seq.sv           # UVM sequence: reset
├── run.do                 # Simulation script for ModelSim/Questa
├── src_files.list         # List of source files for compilation
├── FIFO_UVM_Ahmed_Tarek.pdf # Project documentation
└── .gitattributes
```

## How to Run

1. **Requirements**
   - [QuestaSim](https://eda.sw.siemens.com/en-US/ic/questa/) or ModelSim simulator
   - SystemVerilog and UVM support

2. **Simulation**
   - Open a terminal in the project directory.
   - Run the following command to start the simulation:
     ```sh
     vsim -do run.do
     ```
   - This will compile all sources, run the UVM testbench, and generate coverage data.

3. **Waveform and Coverage**
   - The simulation script adds all interface signals to the waveform window.
   - Coverage results are saved in `FIFO.ucdb`.

## Project Features

- **RTL FIFO**: Parameterized, synthesizable FIFO design.
- **UVM Testbench**: Modular environment with agent, driver, monitor, sequencer, scoreboard, and coverage.
- **Sequences**: Includes read-only, write-only, mixed, and reset sequences.
- **Assertions**: SystemVerilog Assertions (SVA) for protocol and functional checks.
- **Coverage**: Functional coverage for key FIFO scenarios and illegal conditions.
- **Scoreboard**: Reference model for data checking and error reporting.

## Documentation

See [`FIFO_UVM_Ahmed_Tarek.pdf`](FIFO_UVM_Ahmed_Tarek.pdf) for detailed documentation on the design and verification methodology.

## Authors

- Ahmed Tarek (Project)
- Kareem Waseem (RTL Author)

## License

This project is for educational and non-commercial use.

---

*Happy verifying!*