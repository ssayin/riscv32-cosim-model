GENERATED_DIR := $(TB_DIR)uvm_top/
TPL_DIR       := tools/gen/
TPLS          := $(TPL_DIR)axi4master.tpl

$(GENERATED_DIR): $(TPLS)
	@echo "$(GENERATED_DIR) does not exist."
	@echo "Generating $(GENERATED_DIR)."
	$(PROJECT_ROOT)third_party/easier_uvm_gen.pl -m $(TPL_DIR)common.tpl $^ 
