UVM_BFM_DIR    := $(TB_DIR)uvm_bfm/
UVM_TOP_DIR    := $(TB_DIR)uvm_top/

GEN_DIR        := tools/gen/
BFM_TPLS       := $(GEN_DIR)axi4bfm/axi4.tpl
TOP_TPLS       := $(GEN_DIR)riscv_core/riscv_core.tpl

UVM_BFM_COMMON := $(GEN_DIR)axi4bfm/common.tpl
UVM_TOP_COMMON := $(GEN_DIR)riscv_core/common.tpl

define generate_directory
	@echo "$1 does not exist."
	@echo "Generating $1."
	$(PROJECT_ROOT)third_party/easier_uvm_gen.pl -m $2 $3
endef

$(UVM_BFM_DIR):
	$(call generate_directory,$(UVM_BFM_DIR),$(UVM_BFM_COMMON),$(BFM_TPLS))

$(UVM_TOP_DIR):
	$(call generate_directory,$(UVM_TOP_DIR),$(UVM_TOP_COMMON),$(TOP_TPLS))
