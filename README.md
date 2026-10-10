# RISC-V Processor with Hardware MAC Accelerator

A complete RTL-to-synthesis VLSI project implementing a RISC-V processor with a custom hardware Multiply-Accumulate (MAC) accelerator.

## Project Overview

This project implements a RISC-V processor in SystemVerilog and extends it with a custom MAC instruction.

The hardware MAC accelerator performs:

A × B + C

using 32-bit inputs and produces a 64-bit result.

The project covers the complete digital design flow:

RTL Design → Functional Simulation → Custom Instruction → MAC Integration → SKY130 Synthesis → Timing Analysis → Area Analysis

## Architecture

The processor contains:

- Program Counter
- Instruction Memory
- Instruction Decoder
- Control Unit
- Register File
- Immediate Generator
- ALU
- Data Memory
- Custom MAC Instruction Decoder
- MAC Controller
- MAC Execution Unit
- Hardware MAC Unit

### MAC Architecture

```text
                 RISC-V Processor
                        |
                 Custom MAC Instruction
                        |
                MAC Instruction Decoder
                        |
                 MAC Execution Unit
                    /          \
                   /            \
          MAC Controller       MAC Unit
                                |
                              A × B
                                |
                              + C
                                |
                         64-bit MAC Result
                                |
                         Register Writeback
