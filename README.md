# riscv32-cosim-model

<!--toc:start-->
- [riscv32-cosim-model](#riscv32-cosim-model)
  - [Prerequisites](#prerequisites)
  - [Getting Started](#getting-started)
  - [Building and Running](#building-and-running)
  - [Contributing](#contributing)
  - [Authors](#authors)
  - [License](#license)
  - [Acknowledgements](#acknowledgements)
<!--toc:end-->

A work-in-progress RISC-V 32-bit co-simulation model. It includes RTL of a developing RISC-V core design, UVM testbenches, and SystemVerilog DPI (svdpi) interfaces to communicate with the C++ code from the associated projects [riscv32-decoder](https://github.com/ssayin/riscv32-decoder.git) and [riscv32-sim](https://github.com/ssayin/riscv32-sim.git).

## Prerequisites

Before you begin, ensure you have met the following requirements: 
- Vivado 20xx.x
- XSIM
- C/C++ compiler

## Getting Started

1. Clone the repository

```sh
git clone --recursive https://github.com/ssayin/riscv32-cosim-model.git
```

If you have already cloned the repository, you can fetch the submodules with:

```sh
git submodule update --init --recursive
```

2. Navigate to the directory

```sh
cd riscv32-cosim-model
```

## Building and Running

This project uses a Makefile for building and running the co-simulation model. The Makefile provides several targets for different tasks:

- `sim.riscv_decoder`, `sim.top_level`, and `sim.riscv_core`. These targets run the XSIM simulation on different testbenches.

- `quartus_flow`: **(Under Development)** Runs the Quartus flow for synthesis, fitting, and static timing analysis.

- `libdpi.so`: Compile the shared library that exposes [riscv32-decoder](https://github.com/ssayin/riscv32-decoder.git) routines.

- `compile`: Compile the SystemVerilog files using the Xilinx Vivado Suite. 

- `clean`: Remove all generated files from the previous build.

Please check [Makefile](Makefile) for further details.

To build and run the project, follow these steps:

1. Open a terminal in the project root directory.

2. Run the following program:

```sh 
make
```

3. To run the simulation, make these targets in succession:

```sh
make sim.riscv_decoder
make sim.riscv_core
make sim.top_level
```

4. To clean the project (remove all generated files), enter the following command:

```sh
make clean
```

## Contributing

If you would like to contribute, please fork the repository and submit a pull request. For major changes, please open an issue first to discuss what you would like to change.

## Authors
- Serdar Sayın

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE.md](LICENSE) file for details.

## Acknowledgements

I would like to thank the RISC-V community for their comprehensive ISA specification, which made this project possible.
