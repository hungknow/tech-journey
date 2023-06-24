#include <sys/socket.h>
#include "ipc_socket.h"

int server_connection_socket;                 // master socket

void initialize_ipc_socket_server() {
    // Remove the socket in case the program had previously exited abnormally
    unlink(SOCKET_PATH);

    // Create the master (connection) socket
    server_connection_socket = socket(AF_UNIX, SOCK_STREAM, 0);
    if (server_connection_socket < 0) {
        
    }
}