#ifndef IPC_SOCKET_H
#define IPC_SOCKET_H 1

#define SOCKET_PATH "/tmp/daemon_socket"
#define BACKLOG 20                     // maximum size of pending connections
#define BUFFER_SIZE 128                // size of a message between client and server

void initialize_ipc_socket_server();

#endif
