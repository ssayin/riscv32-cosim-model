# Required
package require ::quartus::project

# Set the project name
set project_name "top_level"

# Set the top-level SystemVerilog file
set top_level_file "src/rtl/top_level.sv"

# Set the target device family and part number
set device_family "Cyclone IV E"
# set device_part ""

# Create a new project
project_new $project_name -overwrite

# Set the device family and part number
set_global_assignment -name FAMILY $device_family
# set_global_assignment -name DEVICE $device_part

set_global_assignment -name SEARCH_PATH ./src/rtl/include

# Add the SystemVerilog file to the project
set_global_assignment -name SYSTEMVERILOG_FILE $top_level_file

set qip_path ./ip/intel_ocram_drw_sedge/
set ocram_drw_qip_file $qip_path/intel_ocram_drw_sedge.qip

# add IP block
set_global_assignment -name QIP_FILE $ocram_drw_qip_file

#set_global_assignment -name VERILOG_FILE $ocram_drw_path/intel_ocram_drw_sedge.v

# Set the directory containing your source files
set source_directories [list ./src/rtl/core  ./src/rtl/core/arith ./src/rtl/core/pipeline ./src/rtl/mem_shared ./src/rtl/include]

# Iterate over the source directories
foreach src_dir $source_directories {
    # Use glob to find all SystemVerilog and Verilog files in the current directory
    set systemverilog_files [glob -nocomplain -directory $src_dir *.sv]

    # Add the SystemVerilog files to the project
    foreach sv_file $systemverilog_files {
        set_global_assignment -name SYSTEMVERILOG_FILE $sv_file
    }
 }

# Save the project and close it
project_close
