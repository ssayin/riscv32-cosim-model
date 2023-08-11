dut_top = riscv_core

project = src/tb/uvm_top

dut_source_path = src/rtl/core
inc_path        = tools/gen/riscv_core/include
dut_pfile       = tools/gen/riscv_core/pinlist

name      = Serdar Sayın 
email     = serdarsayin@pm.me
year      = 2023
version   = 0.1

file_header_inc = header_inc

nested_config_objects = yes

backup = no

top_default_seq_count = 1000

top_env_append_to_build_phase    = top_env_append_to_build_phase.sv       inline
top_env_append_to_connect_phase  = top_env_append_to_connect_phase.sv     inline
top_env_inc_inside_class         = top_env_inc_inside_class.sv            inline

#regmodel_file = regmodel.sv
#top_reg_block_type = top_reg_block

#th_generate_clock_and_reset = yes


