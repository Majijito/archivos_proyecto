# MAC/MAS bfloat16 Pipeline Accelerator using OpenLane SKY130

## Overview

This project implements a pipelined MAC/MAS accelerator using the bfloat16 floating-point format in Verilog HDL.
The design was synthesized and implemented as an ASIC using the OpenLane flow and the SKY130 standard cell library.

The accelerator supports:

* MAC operation:

```text id="b23lxn"
ACC = ACC + (A × B)
```

* MAS operation:

```text id="6krh8l"
ACC = ACC - (A × B)
```

The design includes:

* Floating-point multiplier
* Floating-point adder/subtractor
* Accumulator register
* Pipeline stages
* OpenLane physical implementation

---

# Project Structure

```text id="yv7g6w"
archivos_proyecto/
│
├── rtl/                  # Verilog source files
├── tb/                   # Testbenches
├── sim/                  # Simulation outputs
├── openlane/             # OpenLane configuration and runs
├── docs/
│   ├── waveforms/        # GTKWave screenshots
│   ├── rtl_view/         # RTL diagrams
│   ├── layout/           # Layout screenshots
│   └── reports/          # STA and metrics reports
```

---

# Top Module

```text id="g49m0w"
mac_mas_top.v
```

Main inputs:

| Signal | Description          |
| ------ | -------------------- |
| clk    | System clock         |
| rst    | Reset                |
| en     | Enable               |
| opcode | Operation selector   |
| a      | Operand A (bfloat16) |
| b      | Operand B (bfloat16) |

Outputs:

| Signal  | Description         |
| ------- | ------------------- |
| acc_out | Accumulator output  |
| ready   | Operation completed |

---

# Opcode Encoding

| Opcode | Operation |
| ------ | --------- |
| 0011   | MAC       |
| 1011   | MAS       |

---

# RTL Architecture

The design is divided into the following blocks:

1. Floating-point multiplier (`fpmul.v`)
2. Floating-point adder/subtractor (`fp16sum_res_pipe.v`)
3. Pipeline registers
4. Accumulator register
5. Operation control logic

Pipeline stages are used to improve timing performance.

---

# Simulation

Simulation was performed using:

* Icarus Verilog
* GTKWave

The testbench validates:

* MAC operation
* MAS operation
* Pipeline synchronization
* Ready signal timing

Example results:

| Operation | Result |
| --------- | ------ |
| MAC       | 3F80   |
| MAS       | 0000   |

---

# RTL Visualization

RTL visualization was generated using:

* Yosys
* netlistsvg

RTL screenshots are located in:

```text id="ul5ry3"
docs/rtl_view/
```

---

# Physical Design Flow

Physical implementation was performed using:

* OpenLane
* SKY130 PDK

Flow stages:

1. Synthesis
2. Floorplanning
3. Placement
4. Clock Tree Synthesis
5. Routing
6. STA analysis
7. GDS generation

---

# OpenLane Reports

Reports included:

* `summary.rpt`
* `metrics.csv`

Location:

```text id="4xldgz"
docs/reports/
```

---

# Layout

Generated layouts and screenshots are stored in:

```text id="s6g0zs"
docs/layout/
```

Generated GDS:

```text id="8dl6ce"
mac_mas_top.gds
```

---

# Timing Analysis

Post-route STA analysis showed:

* Successful routing
* No hold violations
* Setup violations present in slow corners

Worst setup slack observed:

```text id="z6b4p5"
-0.9157 ns
```

---

# Area Metrics

Area information is available in:

```text id="9yjlwm"
metrics.csv
```

Generated using OpenLane post-layout analysis.

---

# Tools Used

* Verilog HDL
* Icarus Verilog
* GTKWave
* Yosys
* netlistsvg
* OpenLane
* OpenROAD
* SKY130 PDK

---

# Authors

Maria Jose Castañeda - Ana Sofía Giraldo - Luisa Fernanda Vélez - Jorge Esteban Ruiz
Workshop IC Design UTP
2026
