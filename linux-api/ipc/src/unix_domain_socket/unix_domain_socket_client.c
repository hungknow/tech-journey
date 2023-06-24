#include <stdlib.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <signal.h>
#include <errno.h>
#include "unix_domain_socket_server.h"
#include "log.h"

int data_socket;

// Maximum number of characters ofr an integer
#define INT_LEN 12

void shutdown_client(int sig) {
    close(data_socket);
    exit(EXIT_SUCCESS);
}

int main() {
    data_socket = socket(AF_UNIX, SOCK_STREAM, 0);
    if (data_socket < 0) {
        infof("Cannot create client socket\n");
        exit(EXIT_FAILURE);
    }

    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(struct sockaddr_un));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, SOCKET_PATH, sizeof(addr.sun_path) - 1);

    if (connect(data_socket, (struct sockaddr *)&addr, sizeof(struct sockaddr_un)) < 0) {
        infof("Cannot connect ot server\n");
        exit(EXIT_FAILURE);
    }

    signal(SIGINT, shutdown_client);
    
     // ignore SIGPIPE (server disconnects)
    signal(SIGPIPE, SIG_IGN);

    int value = -1;
    do {
        char input[INT_LEN];
        printf("Enter integer to send to server (0 to stop):");
        if (read_line(input, INT_LEN) < 0) {
            printf("EOF, Raising SIGINT.\n");
            raise(SIGINT);
        }

        if (read_int_from_buffer(input, &value) == -1) {
            printf("Not an integer. Try again.\n");
            continue;
        }

        ssize_t num_written = write(data_socket, &value, sizeof(int));
        if (num_written < 0) {
            printf("Error in sending data to server\n");
            if (errno == EPIPE) {
                printf("Server has disconnected. Quitting");
                raise(SIGINT);
            }
            break;
        }

        char write_successful[64];
        sprintf(write_successful,
            "Number of bytes written: %zd; data sent: %d", num_written, value);
        printf("Write successfully: %s\n", write_successful);
    } while (value != 0);

    shutdown_client(SIGINT);
}