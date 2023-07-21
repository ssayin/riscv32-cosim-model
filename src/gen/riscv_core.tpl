agent_name = riscv_core

trans_item = riscv_core_tx

#trans_var = p_if_id_t trace_p_if_id_0;
#trans_var = p_if_id_t trace_p_if_id_1;
#trans_var = p_id_ex_t trace_p_id_ex;
#trans_var = p_ex_mem_t trace_p_ex_mem;
#trans_var = p_mem_wb_t trace_p_mem_wb;

# IRQs
trans_var = logic irq_external;
trans_var = logic irq_timer;
trans_var = logic irq_software;

# Inputs
trans_var = logic [31:0] mem_data_in [2]; 
trans_var = logic mem_ready;

# Outputs
trans_var = logic [31:0] mem_data_out[2];
trans_var = logic [3:0] mem_wr_en [2];
trans_var = logic mem_rd_en [2];
trans_var = logic mem_clk_en;
trans_var = logic [31:0] mem_addr [2];

driver_inc = riscv_core_do_drive.sv  inline
monitor_inc = riscv_core_do_mon.sv   inline
trans_inc_before_class = riscv_core_inc_before_class.sv inline
agent_seq_inc = my_riscv_core_seq.sv inline

agent_factory_set = riscv_core_default_seq my_riscv_core_seq

if_port = logic clk;
if_port = logic rst_n;
if_port = logic [31:0] mem_data_in [2];
if_port = logic mem_ready;
if_port = logic irq_external;
if_port = logic irq_timer;
if_port = logic irq_software;
if_port = logic [31:0] mem_data_out[2];
if_port = logic [3:0] mem_wr_en [2];
if_port = logic mem_rd_en [2];
if_port = logic mem_clk_en;
if_port = logic [31:0] mem_addr [2];
if_clock = clk
