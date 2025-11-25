# RISC-V CPU for Zybo Z7 (XC7Z020)

This project aims to implement two RISC-V CPU architectures on the Zybo Z7-20 FPGA:
1. Single-cycle CPU  
2. 5-stage pipelined CPU with forwarding, hazard detection, and static branch prediction  

Both designs support a limited RV32I subset:
- ADD, SUB, AND, OR, XOR
- ADDI, ANDI, ORI, XORI
- LW, SW
- BEQ, BNE
- JAL, JALR
- LUI

---

# 1. Repo Structure

```
zybo_rv_cpu/
  hdl/
    single_cycle/
      alu.v
      regfile.v
      instr_mem.v
      data_mem.v
      single_cycle_cpu.v
    pipeline/
      alu.v
      regfile.v
      if_stage.v
      if_id_reg.v
      id_stage.v
      id_ex_reg.v
      ex_stage.v
      ex_mem_reg.v
      mem_stage.v
      mem_wb_reg.v
      forwarding.v
      hazard.v
      branch_predictor.v
      instr_mem.v
      data_mem.v
      top_pipeline.v
  sim/
    tb_single.v
    tb_pipeline.v
    asm/
      test_add_store.s
      test_forward.s
      test_load_use.s
  tools/
    mini_assembler.py
  vivado/
    top_zx7.v
    zybo_z7_example.xdc
  docs/
    README.md   <-- This file
```

---

# 2. High-Level Architecture

The project will contain two CPU variants. Both share the ALU, register file, and memory interfaces.

---

# 3. Single-Cycle CPU Overview

## Block Diagram

```
          +-------------------------------+
          |         Single Cycle CPU      |
          |                               |
 PC ----->|  Instruction Memory           |
          +---------------+---------------+
                          |
                          v
                 +----------------+
                 | Instruction    |
                 |   Decode       |
                 +----------------+
                          |
                          v
        +---------+   +--------+   +------------+
        | Register|-->|  ALU   |-->| Data Memory|
        |  File   |   +--------+   +------------+
        +---------+        |
             ^             |
             |             v
             +-------------+
               Write Back
```

## Description

- All datapath operations execute in a single clock cycle.
- No hazards, no pipeline registers.
- Simpler to debug but lower maximum frequency.

---

# 4. Pipelined CPU Overview (5 Stages)

Pipeline Stages:
1. IF — Instruction Fetch  
2. ID — Instruction Decode & Register Read  
3. EX — ALU and Branch Unit  
4. MEM — Load/Store  
5. WB — Register Write Back  

Includes:
- Data forwarding unit  
- Hazard detection unit  
- Branch predictor (static, not-taken default)  

---

## Full 5-Stage CPU Block Diagram

```
   IF Stage                  ID Stage               EX Stage                 MEM Stage              WB Stage
+-----------+        +-------------------+    +----------------+      +----------------+      +----------------+
| PC Logic  |        | Register File     |    |    ALU         |      | Data Memory    |      | Writeback Mux |
| Instr Mem |------->| Imm Gen & Decode  |--->| Branch Compare |----->| Load/Store     |----->| Regfile Write |
+-----------+        +-------------------+    +----------------+      +----------------+      +----------------+
      |                        |                     |                         |                      |
      |                        |                     |                         |                      |
      v                        v                     v                         v                      v

   IF/ID Reg ----------> ID/EX Reg ----------> EX/MEM Reg ----------> MEM/WB Reg ------------------> Regfile
```

---

## Forwarding Unit Diagram

```
                 +-----------------------+
   EX/MEM.rd --->|                       |
   MEM/WB.rd --->|   Forwarding Unit     |----> ForwardA/B control
   ID/EX.rs1 --->|                       |
   ID/EX.rs2 --->|                       |
                 +-----------------------+
```

## Hazard Detection Unit Diagram

```
              +--------------------------------------------+
 ID/EX.MemRead|                                            |
    IF/ID.rs1 |----> Hazard Detection Unit -> stall/flush  |
    IF/ID.rs2 |                                            |
               --------------------------------------------+
```

## Branch Predictor Diagram (Static Not-Taken)

```
 PC ---> Predictor (always not taken) ---> Next PC logic
```

---

# 5. Tooling

### Mini Assembler (`tools/mini_assembler.py`)
- Converts simplified assembly into machine code.
- Outputs hex suitable for initializing instruction memory.

### Example Assembly Tests
Located in `sim/asm/`:
- `test_add_store.s`
- `test_forward.s`
- `test_load_use.s`

---

# 6. Simulation

## Single-Cycle Testbench
```
sim/tb_single.v
```

## Pipeline Testbench
```
sim/tb_pipeline.v
```

Run with:
```
iverilog -o sim_single sim/tb_single.v hdl/single_cycle/*.v
vvp sim_single
```

Pipeline:
```
iverilog -o sim_pipe sim/tb_pipeline.v hdl/pipeline/*.v
vvp sim_pipe
```

---

# 7. FPGA Build Instructions (Vivado)

1. Open Vivado  
2. Create a new Zynq-7000 project  
3. Add RTL sources from:
   ```
   hdl/single_cycle/      OR
   hdl/pipeline/
   ```
4. Add top-level FPGA wrapper:
   ```
   vivado/top_zx7.v
   ```
5. Add Zybo constraints:
   ```
   vivado/zybo_z7_example.xdc
   ```
6. Generate Bitstream  
7. Program FPGA  

