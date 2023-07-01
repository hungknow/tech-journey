#ifndef _LOG_H_
#define _LOG_H_ 1

#include <stdio.h>
#include <stdarg.h>

extern FILE *log_stream;

void init_log(const char *log_file_name, const char *app_name);
void uninit_log();
int infof(const char *fmt, ...);

#endif