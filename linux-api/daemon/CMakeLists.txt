cmake_minimum_required (VERSION 2.6)
project(daemon)

add_subdirectory(src)

# Directory with configuration files
set (DAEMON_CONF_DIR "/etc/daemon")

# Directory with systemd unit files
set (SYSTEMD_UNIT_DIR "/usr/lib/systemd/system/")

# Default directory for log file
set (DAEMON_LOG_DIR "/var/log/daemon")

# Default directory for PID file
set (DAEMON_PID_DIR "/run/daemon")

function(install_conf src dest)
    if(NOT IS_ABSOLUTE "${src}")
        set(src "${CMAKE_CURRENT_SOURCE_DIR}/${src}")
    endif()

    get_filename_component(src_name "${src}" NAME)

    if (NOT IS_ABSOLUTE "${dest}")
        set(dest "${CMAKE_INSTALL_PREFIX}/${dest}")
    endif()

    # install(CODE "
    # #file(INSTALL \"${src}\" DESTINATION \"${dest}\")
    # message(STATUS \"Installing: \$ENV{DESTDIR}${dest}/${src_name}\")
    # execute_process(COMMAND \${CMAKE_COMMAND} -E copy \"${src}\"
    #                 \"\$ENV{DESTDIR}${dest}/${src_name}\"
    #                 RESULT_VARIABLE copy_result
    #                 ERROR_VARIABLE error_output)
    # if(copy_result)
    #     message(FATAL_ERROR \${error_output})
    # endif() 
    # ")
    install(
        FILES ${src}
        DESTINATION $ENV{DESTDIR}${dest}/
        COMPONENT config
    )

endfunction(install_conf)

# Install configuration file
install_conf (./daemon.conf ${DAEMON_CONF_DIR})

# Install systemd unit files 
install_conf (./simple-daemon.service ${SYSTEMD_UNIT_DIR})
install_conf (./forking-daemon.service ${SYSTEMD_UNIT_DIR})