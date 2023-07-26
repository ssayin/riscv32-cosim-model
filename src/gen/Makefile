TPLS := busf.tpl busm.tpl

gen: $(TPLS)
	@echo "Regenerating UVM_TOP"
	$(RM) -r ../tb/uvm_top/
	../../third_party/easier_uvm_gen.pl $^ 
