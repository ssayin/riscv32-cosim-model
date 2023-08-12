dut_top = riscv_core

project = src/tb/uvm_bfm

dut_source_path  = src/rtl/core
inc_path         = tools/config/uvm/include
dut_pfile        = tools/config/uvm/tpl/bfm/pinlist
prefix           = bfm

name      = Serdar Sayın 
email     = serdarsayin@pm.me
year      = 2023
version   = 0.1

file_header_inc = header_inc

nested_config_objects = yes

backup = no
comments_at_include_locations = no

split_transactors = yes

top_default_seq_count = 300
#top_env_inc_before_class = top_env_inc_before_class.sv inline

#ref_model_input = reference m_riscv_core_agent

#ref_model_inc_inside_class = reference reference_inc_inside_class.sv inline
#ref_model_inc_after_class = reference reference_inc_after_class.sv inline

#ref_model_compare_method = reference io

th_generate_clock_and_reset = yes

#regmodel_file = regmodel.sv
#top_reg_block_type = top_reg_block
