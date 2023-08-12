m_ref_model = riscv_core_ref_model::type_id::create("m_ref_model", this);
//coverage =
//    riscv_core_coverage#(riscv_core_transaction)::type_id::create("coverage", this);
m_scoreboard = riscv_core_scoreboard::type_id::create("m_scoreboard", this);

