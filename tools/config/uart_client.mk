# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

JTAG_ATLANTIC      := -ljtag_atlantic -ljtag_client
JTAG_ATLANTIC_PATH := $(QUARTUS_ROOT)linux64
JTAG_ATLANTIC_FLAG := -L$(JTAG_ATLANTIC_PATH)

UART_CLIENT        := uart_client

$(UART_CLIENT): $(TOOLS_DIR)uart_client.c $(THIRD_PARTY)jtag_atlantic/common.c
	$(CXX) $(CFLAGS) -o $@ $^ $(JTAG_ATLANTIC_FLAG) $(JTAG_ATLANTIC) -I$(PROJECT_ROOT)third_party/jtag_atlantic
