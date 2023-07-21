# qsys scripting (.tcl) file for platform
package require -exact qsys 16.0

create_system {platform}

set_project_property DEVICE_FAMILY {Cyclone IV E}
set_project_property DEVICE {EP4CE6E22C8}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance clk_0 clock_source 22.1
set_instance_parameter_value clk_0 {clockFrequency} {50000000.0}
set_instance_parameter_value clk_0 {clockFrequencyKnown} {1}
set_instance_parameter_value clk_0 {resetSynchronousEdges} {DEASSERT}

add_instance riscv_core_0 riscv_core 1.0

add_instance ssram_0 altera_up_avalon_ssram 18.0
set_instance_parameter_value ssram_0 {board} {DE2i-150}
set_instance_parameter_value ssram_0 {pixel_buffer} {0}

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF clk_0.clk_in
add_interface rst_n reset sink
set_interface_property rst_n EXPORT_OF clk_0.clk_in_reset

# connections and connection parameters
add_connection clk_0.clk riscv_core_0.clk

add_connection clk_0.clk ssram_0.clk

add_connection clk_0.clk_reset riscv_core_0.rst

add_connection clk_0.clk_reset ssram_0.reset

add_connection riscv_core_0.altera_axi4_master_1 ssram_0.avalon_ssram_slave
set_connection_parameter_value riscv_core_0.altera_axi4_master_1/ssram_0.avalon_ssram_slave arbitrationPriority {1}
set_connection_parameter_value riscv_core_0.altera_axi4_master_1/ssram_0.avalon_ssram_slave baseAddress {0x0000}
set_connection_parameter_value riscv_core_0.altera_axi4_master_1/ssram_0.avalon_ssram_slave defaultConnection {0}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {platform.qsys}
