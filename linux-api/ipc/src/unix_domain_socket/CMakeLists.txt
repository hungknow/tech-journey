set(unix_domain_socket_server_src
    unix_domain_socket_server.c
    ../log.c
    ../utils.c)

add_executable(unix_domain_socket_server ${unix_domain_socket_server_src})