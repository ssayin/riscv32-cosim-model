// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "common.h"
#include "jtag_atlantic.h"

#define BUF_SIZE 64

static char buf[BUF_SIZE];

int main(int argc, char **argv) {

  char *cable_name = NULL;
  int device = -1;
  int instance = -1;
  char buf[256];
  int len;

  if (argc < 2) {
    if (fgets(buf, 256, stdin) != NULL) {
      len = 0;
      while (buf[len] != '\0' && buf[len] != '\n') {
        len++;
      }
    } else {
      fprintf(stderr, "Error input");
      return 1;
    }
  }

  struct JTAGATLANTIC *atlantic =
      jtagatlantic_open(cable_name, device, instance, argv[0]);
  if (!atlantic) {
    show_err();
    return 1;
  }

  show_info(atlantic);

  fprintf(stdout, "\nUnplug the cable or press CTRL+C to stop.\n\n");

  fprintf(stdout, "Sending command: '%s'.\n", argv[1]);

  int ret = jtagatlantic_write(atlantic, argv[1], strlen(argv[1]));

  fprintf(stdout, "%ld character(s) sent to JTAG UART.\n", strlen(argv[1]));

  jtagatlantic_flush(atlantic);

  while (jtagatlantic_read(atlantic, buf, sizeof(buf)) > -1) {
    fwrite(buf, ret, 1, stdout);
    usleep(10000);
  }

  jtagatlantic_close(atlantic);

  return 0;
}
