#include <stdlib.h>
#include <unistd.h>
#include <sys/un.h>
#include <sys/socket.h>
#include <signal.h>
#include "unix_domain_socket_server.h"
#include "../log.h"

int server_connection_socket;                 // master socket

static void shutdown_server(int sig) {
    close(server_connection_socket);
    infof("Connection closed.");
    unlink(SOCKET_PATH);

    exit(EXIT_SUCCESS);
}

void initialize_ipc_socket_server() {
    // Remove the socket in case the program had previously exited abnormally
    unlink(SOCKET_PATH);

    // Create the master (connection) socket
    server_connection_socket = socket(AF_UNIX, SOCK_STREAM, 0);
    if (server_connection_socket < 0) {
       infof("Cannot create master socket.\n");
       exit(EXIT_FAILURE); 
    }

    infof("Master socket created.");

    // Construct server socket address
    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(struct sockaddr_un));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, SOCKET_PATH, sizeof(addr.sun_path) - 1);

    // Bind socket to socket address
    if (bind(server_connection_socket, (struct sockaddr *)&addr, sizeof(struct sockaddr_un)) < 0) {
        infof("Cannot bind socket");
        exit(EXIT_FAILURE);
    }
    infof("Master socket bound to the socket address");

    // Make the master socket a listening socket
    if (listen(server_connection_socket, BACKLOG) == -1) {
        infof("Cannot set master socket as listening socket");
        exit(EXIT_FAILURE);
    }

    // register SIGINT handler to shutdown server cleanly
    signal(SIGINT, shutdown_server);

    // ignore SIGPIPE: when client disconnects without waiting for message
    signal(SIGPIPE, SIG_IGN);
}

int handle_connection_initiation_request()
{
    int data_socket = accept(server_connection_socket, NULL, NULL);
    if (data_socket < 0) {
        infof("cannot accept client connection\n");
        exit(EXIT_FAILURE);
    }
    infof("Connection accepted form the client");
    return data_socket;
}

void handle_server_request(const int data_socket, char *buffer, int *sum) {
    for (;;) {
        memset(buffer, 0, BUFFER_SIZE);

        infof("Waiting for data from the client");
        if (read(data_socket, buffer, BUFFER_SIZE) < 0) {
            infof("Cannot read data from client");
            exit(EXIT_FAILURE);
        }

        int data;
        memcpy(&data, buffer, sizeof(int));
        if (data == 0) {
            break;
        }

        *sum += data;
    }
}

int main() {
    return 0;
}
