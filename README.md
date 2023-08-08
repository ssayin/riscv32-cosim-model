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
- make
- p7zip or any other software that supports v2.0 DEFLATE can be used. If you decide to use a different software, you will need to adjust [common.mk](config/common.mk) accordingly.
- jq
- perl

### Optional

To use Easier UVM perl script you'll need: 
- perl>=5.8.0.
- the following packages, which can be installed either through CPAN or your distribution's package manager:

```perl
use File::Copy::Recursive qw(dircopy);
use File::Copy "cp";
use File::stat;
```

## Getting Started

1. Clone the repository

```sh
git clone --recursive https://github.com/ssayin/riscv32-cosim-model.git
```

2. Navigate to the directory

```sh
cd riscv32-cosim-model
```

If you have already cloned the repository, you can fetch the submodules with:
```sh
git submodule update --init --recursive
```

## Building and Running

### Simulation

This project uses a Makefile for building and running the co-simulation model. The Makefile provides several targets for different tasks:

- `libdpi.so`: Compile the shared library that exposes [riscv32-decoder](https://github.com/ssayin/riscv32-decoder.git) routines.

- `compile`: Compile the SystemVerilog files using the Xilinx Vivado Suite. 

- `clean`: Remove all generated files from the previous build.

Please check [Makefile](Makefile) for further details.

To build and run the project, follow these steps:

1. Open a terminal in the project root directory.

2. Run the following program:

```sh
make sim
```

4. To clean the project (remove all generated files), enter the following command:

```sh
make clean
```

### Synthesis

```sh
./tools/intel_synth.sh
```

### Intel JTAG UART

To build and run the UART tool, follow these steps:

1. Set the `QUARTUS_ROOT` environment variable to the path of your Quartus installation. For example, if you're using Quartus version 22.1 Lite and it's installed at `/opt/intelFPGA_lite/22.1std/quartus/`, you can set it using the following command:
```sh
export QUARTUS_ROOT=/opt/intelFPGA_lite/22.1std/quartus/
```

2. Build the UART client by running the following program:
```sh 
make QUARTUS_ROOT=$QUARTUS_ROOT uart_client
```
**Important**: Whenever you open a new shell session to work with the UART tool, remember to reset the LD\_LIBRARY\_PATH using the previously defined QUARTUS\_ROOT value. Exporting this variable in a file sourced by your shell i.e. your .bashrc can save you a big time.

3. Edit the [./tools/uart](./tools/uart) file and adjust the LD\_LIBRARY\_PATH variable to include $QUARTUS\_ROOT:
```sh 
LD_LIBRARY_PATH=$QUARTUS_ROOT uart_client $@
```

4. Run the program:
```sh 
./tools/uart Hi
```
Replace "Hi" with whichever message you want to transmit. 

**Important**: 
1. Your string should not contain escaped 0's (\0), i.e. NULL terminators. This is due to my reliance on strlen(...) to determine string length.

2. Your string should not contain space characters as the shell will treat your argument as many arguments. For that reason, enclosing your text in double quotes will not work either.

I might consider incorporating support for pipes or reading from stdin at a later point.

## Contributing

If you would like to contribute, please fork the repository and submit a pull request. For major changes, please open an issue first to discuss what you would like to change.

## Authors
- Serdar Sayın

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

I would like to thank the RISC-V community for their comprehensive ISA specification, which made this project possible.

### External 

- [alterajtaguart](https://github.com/thotypous/alterajtaguart) by [thotypous](https://github.com/thotypous): Disassembling `jtag_atlantic.so` and providing an associated API.

- [jtag_uart_example](https://github.com/tomverbeure/jtag_uart_example) by [tomverbeure](https://github.com/tomverbeure): Providing examples for integrating the [Intel JTAG UART API](https://github.com/thotypous/alterajtaguart) into projects.

