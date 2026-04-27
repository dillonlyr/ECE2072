# ECE2072 – Digital Systems / FPGA Design

This repository contains my ECE2072 digital systems coursework, including laboratory exercises, Verilog/SystemVerilog source files, Quartus projects, ModelSim simulation files, FPGA pin assignment files, and a larger processor/ALU-based assignment.

The work focuses on digital logic design, FPGA implementation, simulation, and hardware interaction using Intel/Altera FPGA development tools.

---

## Repository Overview

```text
ECE2072/
│
├── Assignment/
│   ├── ALU_tb.v
│   ├── analysis.v
│   ├── bcd.v
│   ├── components.v
│   ├── components_tb.v
│   ├── proc_extension.v
│   ├── proc_extension_tb.v
│   ├── register_tb.v
│   ├── sign_extend_tb.v
│   ├── tick_FSM_tb.v
│   ├── mult.v
│   ├── divide16_v2.v
│   ├── Assignment.qpf
│   ├── Assignment.qsf
│   └── report / submission files
│
├── Lab0/
│   └── Introductory Quartus schematic project
│
├── Lab1/
│   ├── half_adder.bdf
│   ├── full_adder.bdf
│   ├── mux_2_to_1.bdf
│   ├── mux_2_to_1.v
│   └── mux_instantiate.v
│
├── Lab2/
│   ├── full_adder.v
│   ├── half_adder.v
│   ├── ripple_carry_adder.v
│   ├── wallace_tree.v
│   ├── comparison_module.v
│   ├── lab2_task3.v
│   ├── lab2_task4.v
│   ├── example_testbench.v
│   └── ones_counting_testbench.v
│
├── Lab3/
│   ├── clock_10.v
│   ├── clock_100.v
│   ├── divide_7bit.v
│   ├── shift_reg.v
│   └── stopwatch.v
│
├── Lab4/
│   ├── JTAG_UART_MODULE.v
│   ├── jtag_intro.v
│   ├── jtag_uart.v
│   ├── lab4_task2.v
│   ├── mod_10_counter_v1.v
│   ├── sequence_detector.v
│   ├── sequence_detector_part_2.v
│   └── sequence_detector_part_3.v
│
├── python/
│   ├── GameOfLife.py
│   ├── intel_jtag.py
│   ├── jtag_intro.py
│   └── JTAG DLL files
│
├── DE10-Lite_Pin_Assignments.csv
└── DE2_115_pin_assignments.csv
```

---

## Folder Details

### Lab0

This folder contains the introductory Quartus project. It includes basic schematic design files and Quartus project files. The aim of this lab is to become familiar with the Quartus design environment, schematic entry, project setup, and FPGA compilation workflow.

### Lab1

This lab focuses on basic combinational logic circuits. It includes schematic and Verilog implementations of simple logic blocks such as:

- Half adder
- Full adder
- 2-to-1 multiplexer
- Multiplexer instantiation

This lab introduces the relationship between schematic-based design and HDL-based design.

### Lab2

This lab expands into larger combinational arithmetic circuits and testbench-based verification. It includes modules such as:

- Half adder
- Full adder
- Ripple carry adder
- Wallace tree multiplier
- Comparison module
- BCD/division-related modules
- Ones-counting testbench
- Example Verilog testbenches

The key purpose of this lab is to practise modular Verilog design and verify circuit behaviour through simulation.

### Lab3

This lab focuses on sequential logic and timing-based circuits. It includes:

- Clock divider modules
- Shift register
- 7-bit divider
- Stopwatch implementation

This lab demonstrates the use of registers, clocked logic, counters, and timing control in FPGA systems.

### Lab4

This lab introduces communication between the FPGA and an external host using JTAG UART. It includes:

- JTAG UART modules
- Introductory JTAG communication design
- Mod-10 counter
- Sequence detector modules
- Task-specific Verilog designs

This lab connects FPGA logic with host-side interaction and supports hardware/software communication concepts.

### Assignment

The assignment folder contains a larger digital system design project. It includes Verilog modules and testbenches for processor-related components such as:

- ALU testing
- Register testing
- Sign extension testing
- Tick FSM testing
- Component-level verification
- Processor extension logic
- Multiplication and division modules
- BCD display logic
- Quartus project files
- Simulation reports
- Final submission/report files

This section represents the most complete system-level work in the repository and combines multiple digital design concepts into a larger FPGA-based design.
