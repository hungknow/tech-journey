#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <syslog.h>
#include <string.h>
#include <errno.h>
#include <getopt.h>
#include <signal.h>
#include <sys/stat.h>
#include <sys/types.h>

static int running = 0;
static int delay = 1;
static int counter = 0;
static FILE *log_stream = NULL;
static char *app_name = NULL;
static char *pid_file_name = NULL;
static char *conf_file_name = NULL;

int read_conf_file(int reload)
{
    FILE *conf_file = NULL;
    int ret = -1;

    if (conf_file_name == NULL)
        return 0;

    conf_file = fopen(conf_file_name, "r");

    if (conf_file == NULL)
    {
        syslog(LOG_ERR, "Can not open config file: %s, error: %s",
               conf_file_name, strerror(errno));
        return -1;
    }

    ret = fscanf(conf_file, "%d", &delay);

    if (ret > 0)
    {
        if (reload == 1)
        {
            syslog(LOG_INFO, "Reloaded configuration file %s of %s",
                   conf_file_name,
                   app_name);
        }
        else
        {
            syslog(LOG_INFO, "Configuration of %s read from file %s",
                   app_name,
                   conf_file_name);
        }
    }

    fclose(conf_file);

    return ret;
}

// Callback function for handling signals
void handle_signal(int sig)
{
    if (sig == SIGINT)
    {
        fprintf(log_stream, "Debug: stopping daemon ...\n");

        running = 0;
        /* Reset signal handling to default behavior */
        signal(SIGINT, SIG_DFL);
    }
    else if (sig == SIGHUP)
    {
        fprintf(log_stream, "Debug: reloading daemon config file ...\n");
        read_conf_file(1);
    }
}

// This function will daemonize this app
static void daemonize()
{
    pid_t pid = 0;
    int fd;

    /* Fork off the parent process */
    pid = fork();

    if (pid < 0)
    {
        exit(EXIT_FAILURE);
    }

    /* Success: Let the parent terminate */
    if (pid > 0)
    {
        exit(EXIT_SUCCESS);
    }

    /* On success: The child process becomes session leader */
    if (setsid() < 0)
    {
        exit(EXIT_FAILURE);
    }

    /* Ignore signal sent from child to parent process */
    signal(SIGCHLD, SIG_IGN);

    /* Reopen stdin (fd = 0), stdout (fd = 1), stderr (fd = 2) */
    stdin = fopen("/dev/null", "r");
    stdout = fopen("/dev/null", "w+");
    stderr = fopen("/dev/null", "w+");

    /* Try to write PID of daemon to lockfile */
    if (pid_file_name != NULL)
    {
    }
}

void print_help(void)
{
    printf("\n Usage: %s [OPTIONS]\n\n", app_name);
    printf("  Options:\n");
    printf("   -h --help                 Print this help\n");
    printf("   -c --conf_file filename   Read configuration from the file\n");
    printf("   -t --test_conf filename   Test configuration file\n");
    printf("   -l --log_file  filename   Write logs to the file\n");
    printf("   -d --daemon               Daemonize this application\n");
    printf("   -p --pid_file  filename   PID file used by daemonized app\n");
    printf("\n");
}

int main(int argc, char *argv[])
{
    static struct option long_options[] = {
        {"conf_file", required_argument, 0, 'c'},
        {"log_file", required_argument, 0, 'l'},
        {"daemon", no_argument, 0, 'd'},
        {"help", no_argument, 0, 'h'},
        {"pid_file", required_argument, 0, 'p'},
        {NULL, 0, 0, 0}};

    int value, ret, option_index = 0;
    char *log_file_name = NULL;
    int start_daemonized = 0;

    app_name = argv[0];

    while ((value = getopt_long(argc, argv, "c:l:p:dh", long_options, &option_index)) != -1)
    {
        switch (value)
        {
        case 'c':
            conf_file_name = strdup(optarg);
            break;
        case 'l':
            log_file_name = strdup(optarg);
            break;
        case 'p':
            pid_file_name = strdup(optarg);
            break;
        case 'd':
            start_daemonized = 1;
            break;
        case 'h':
            print_help();
            return EXIT_SUCCESS;
        case '?':
            print_help();
            return EXIT_FAILURE;
        default:
            break;
        }
    }

    /* When daemonizing is requested at command line. */
    if (start_daemonized == 1)
    {
        daemonize();
    }

    // Open system log and write message to it
    openlog(argv[0], LOG_PID | LOG_CONS, LOG_DAEMON);
    syslog(LOG_INFO, "Started %s", app_name);

    /* Daemon will handle two signals */
    signal(SIGINT, handle_signal);
    signal(SIGHUP, handle_signal);

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

    /* Read configuration from config file */
    read_conf_file(0);

    running = 1;

    while (running)
    {
        ret = fprintf(log_stream, "Debug: %d\n", counter++);
        if (ret < 0)
        {
            syslog(LOG_ERR, "Can not write to log stream: %s, error: %s",
                   (log_stream == stdout) ? "stdout" : log_file_name, strerror(errno));
        }

        ret = fflush(log_stream);
        if (ret != 0)
        {
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
    if (log_stream != stdout)
    {
        fclose(log_stream);
    }

    /* Write system log and close it. */
    syslog(LOG_INFO, "Stopped %s", app_name);
    closelog();

    if (conf_file_name != NULL)
        free(conf_file_name);
    if (log_file_name != NULL)
        free(log_file_name);
    if (pid_file_name != NULL)
        free(pid_file_name);

    return 0;
}