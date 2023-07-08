dut_top = riscv_core

nested_config_objects = yes

top_default_seq_count = 5
#top_env_inc_before_class = top_env_inc_before_class.sv inline

syosil_scoreboard_src_path = ../../third_party/SyoSil/src

ref_model_input = reference m_riscv_core_agent

ref_model_inc_inside_class = reference reference_inc_inside_class.sv inline
ref_model_inc_after_class = reference reference_inc_after_class.sv inline

ref_model_compare_method = reference iop
