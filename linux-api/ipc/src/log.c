
#include <stdio.h>
#include <syslog.h>
#include <errno.h>
#include <string.h>
#include "log.h"

FILE *log_stream = NULL;

void init_log(const char *log_file_name, const char *app_name)
{
    // Open system log and write message to it
    openlog(app_name, LOG_PID | LOG_CONS, LOG_DAEMON);
    syslog(LOG_INFO, "Started %s", app_name);

    /* Try to open log file to this daemon */
    if (log_file_name != NULL)
    {
        log_stream = fopen(log_file_name, "a+");
        if (log_stream == NULL)
        {
            syslog(LOG_ERR, "Can not open log file: %s, error: %s",
                   log_file_name, strerror(errno));
            log_stream = stdout;
        }
    }
    else
    {
        log_stream = stdout;
    }
}

void uninit_log()
{
    /* Close log file, when it is used. */
    if (log_stream != stdout)
    {
        fclose(log_stream);
    }

    /* Write system log and close it. */
    // syslog(LOG_INFO, "Stopped %s", app_name);
    closelog();
}

int infof(const char *fmt, ...)
{
    va_list args;
    va_start(args, fmt);

    int ret = vfprintf(log_stream, fmt, args);
    va_end(args);
    return ret;
}