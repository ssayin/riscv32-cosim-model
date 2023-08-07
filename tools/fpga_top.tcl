# Required
package require ::quartus::project

# Set the project name
set project_name "fpga_top"

# Set the target device family and part number
set device_family "Cyclone IV E"
set device_part EP4CE6E22C8

# Create a new project
project_new $project_name -overwrite

# Set the top-level SystemVerilog file
set top_level_file "./src/rtl/fpga_top.sv"

# Add the SystemVerilog file to the project
set_global_assignment -name SYSTEMVERILOG_FILE $top_level_file

# Set the device family and part number
set_global_assignment -name FAMILY $device_family
set_global_assignment -name DEVICE $device_part

set_global_assignment -name SEARCH_PATH ./src/rtl/include

set qip_path ./third_party/ip/intel
#set ocram_drw_qip_file $qip_path/intel_ocram_drw_sedge/intel_ocram_drw_sedge.qip
#set platform_qip_file $qip_path/platform/synthesis/platform.qip
set cycloneiv_qip_file $qip_path/synthesis/cycloneiv.qip

# add IP block
# set_global_assignment -name QIP_FILE $ocram_drw_qip_file
# set_global_assignment -name QIP_FILE $platform_qip_file
set_global_assignment -name QIP_FILE $cycloneiv_qip_file

#set_global_assignment -name VERILOG_FILE $ocram_drw_path/intel_ocram_drw_sedge.v

# Set the directory containing your source files
set source_directories [list ./src/rtl/include ./src/rtl/core/exu ./src/rtl/core/dec ./src/rtl/core/ifu ./src/rtl/core/mem ./src/rtl/core ]

set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/sync_fifo.sv

# Iterate over the source directories
foreach src_dir $source_directories {
    # Use glob to find all SystemVerilog and Verilog files in the current directory
    set systemverilog_files [glob -nocomplain -directory $src_dir *.svh *.sv]

    # Add the SystemVerilog files to the project
    foreach sv_file $systemverilog_files {
        set_global_assignment -name SYSTEMVERILOG_FILE $sv_file
    }
 }

set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/fpga_top.sv

# Save the project and close it
project_close