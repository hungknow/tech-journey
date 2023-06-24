#include <stdio.h>
#include <unistd.h>
#include <syslog.h>
#include <string.h>
#include <errno.h>

static int running = 0;
static int delay = 1;
static int counter = 0;
static FILE* log_stream = NULL;
static char *app_name = NULL;

int main(int argc, char *argv[]) {
    int ret;
    char *log_file_name = NULL;

    app_name = argv[0];
    log_stream = stdout;

    running = 1;

    while (running) {
        ret = fprintf(log_stream, "Debug: %d\n", counter++);
        if (ret < 0) {
            syslog(LOG_ERR, "Can not write to log stream: %s, error: %s",
                (log_stream == stdout) ? "stdout" : log_file_name, strerror(errno));
        }

        ret = fflush(log_stream);
		if (ret != 0) {
			syslog(LOG_ERR, "Can not fflush() log stream: %s, error: %s",
				(log_stream == stdout) ? "stdout" : log_file_name, strerror(errno));
			break;
		}
        
        /* Real server should use select() or poll() for waiting at
		 * asynchronous event. Note: sleep() is interrupted, when
		 * signal is received. */
        sleep(delay);
    }

    /* Close log file, when it is used. */
	if (log_stream != stdout) {
		fclose(log_stream);
	}

    /* Write system log and close it. */
	syslog(LOG_INFO, "Stopped %s", app_name);

    return 0;
}