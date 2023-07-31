dut_top = riscv_core

project = ../tb/uvm_top

dut_source_path = ../rtl/core

name      = Serdar Sayın 
email     = serdarsayin@pm.me
year      = 2023
version   = 0.1

file_header_inc = header_inc

nested_config_objects = yes

backup = no

split_transactors = yes

top_default_seq_count = 15
#top_env_inc_before_class = top_env_inc_before_class.sv inline

syosil_scoreboard_src_path = ../../third_party/syoscb-1.0.2.4/src

#ref_model_input = reference m_riscv_core_agent

#ref_model_inc_inside_class = reference reference_inc_inside_class.sv inline
#ref_model_inc_after_class = reference reference_inc_after_class.sv inline

#ref_model_compare_method = reference io

th_generate_clock_and_reset = yes
