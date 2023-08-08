# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: MIT

CXX                ?= g++
CFLAGS             ?= -O2
CXX_FLAGS          ?= $(CFLAGS)

JTAG_ATLANTIC      := -ljtag_atlantic -ljtag_client
JTAG_ATLANTIC_PATH := $(QUARTUS_ROOT)linux64
JTAG_ATLANTIC_FLAG := -L$(JTAG_ATLANTIC_PATH)

CLIENT_SRC         := $(PROJECT_ROOT)src/client/
CLIENT             := uart_client

run: $(CLIENT)
	LD_LIBRARY_PATH=$(JTAG_ATLANTIC_PATH) ./$(CLIENT)

$(CLIENT): $(CLIENT_SRC)uart_client.c $(PROJECT_ROOT)third_party/jtag_atlantic/common.c
	$(CXX) $(CFLAGS) -o $@ $^ $(JTAG_ATLANTIC_FLAG) $(JTAG_ATLANTIC) -I$(PROJECT_ROOT)third_party/jtag_atlantic
