# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: MIT

PROJECT_ROOT := $(CURDIR)/
BUILD_DIR    := $(PROJECT_ROOT)build/
TOOLS_DIR    := $(PROJECT_ROOT)tools/
LIB_DIR      := $(PROJECT_ROOT)
CONFIG_DIR   := $(PROJECT_ROOT)config/

SIM          ?= xsim

ifeq ($(SIM),)
all:
	@echo "Simulator is not specified. Cannot proceed."
	@echo "Specify the simulator as follows:"
	@echo "make SIM=<sim>"
else ifeq ($(SIM),xsim)
	include $(CONFIG_DIR)xsim.mk
endif

.PHONY clean:
	${RM} -rf $(BUILD_DIR) 
	${RM} -rf greybox_tmp/
	${RM} $(LIB)
	${RM} *.jou
	${RM} *.log
	${RM} *.pb
	${RM} -rf ./xsim.dir
	${RM} -rf ./xsim.covdb
	${RM} -rf ./out
	${RM} -rf ./db/
	${RM} -rf ./incremental_db/
	${RM} *.rpt
	${RM} *.summary
	${RM} *.qpf
	${RM} *.qsf
	${RM} *.bak
	${RM} *.txt
	${RM} *.done
	${RM} *.jdi
	${RM} *.pin
	${RM} *.sld
	${RM} *.sof
	${RM} *.smsg
	${RM} *.qws
	${RM} *.wdb
