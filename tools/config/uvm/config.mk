# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

UVM_GENERATOR    := $(THIRD_PARTY)easier_uvm_gen.pl

GEN_DIR          := tools/config/uvm/
TPL_DIR          := $(GEN_DIR)tpl/

GEN_UVM_BFM_DIR  := $(TB_DIR)uvm_bfm/
GEN_UVM_TOP_DIR  := $(TB_DIR)uvm_top/

BFM_CONFIG_ROOT  := $(TPL_DIR)bfm/
TOP_CONFIG_ROOT  := $(TPL_DIR)top/

UVM_BFM_FLIST    := $(BFM_CONFIG_ROOT)flist.xsim
UVM_TOP_FLIST    := $(TOP_CONFIG_ROOT)flist.xsim

UVM_BFM_COMMON   := $(TPL_DIR)bfm.tpl
UVM_TOP_COMMON   := $(TPL_DIR)top.tpl

BFM_TPLS         := $(wildcard $(BFM_CONFIG_ROOT)*.tpl)
TOP_TPLS         := $(wildcard $(TOP_CONFIG_ROOT)*.tpl)


define generate_uvm
	@echo "$1 does not exist."
	@echo "Generating $1."
	$(UVM_GENERATOR) -m $2 $3
endef

$(GEN_UVM_BFM_DIR): $(UVM_BFM_COMMON) $(BFM_TPLS)
	$(call generate_uvm,$(UVM_BFM_DIR),$(UVM_BFM_COMMON),$(BFM_TPLS))

$(GEN_UVM_TOP_DIR): $(UVM_TOP_COMMON) $(TOP_TPLS)
	$(call generate_uvm,$(UVM_TOP_DIR),$(UVM_TOP_COMMON),$(TOP_TPLS))
