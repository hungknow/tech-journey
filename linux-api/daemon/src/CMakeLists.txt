set(daemon_src 
    daemon.c
    log.c)

if (CMAKE_COMPILER_IS_GNUCC)
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        set (CMAKE_C_FLAGS "-D_REETRANT -ggdb -fPIC -Wall -Wextra -pedantic -O0")
    elseif( CMAKE_BUILD_TYPE STREQUAL "Release" )
        set (CMAKE_C_FLAGS "-D_REETRANT -DNDEBUG -fPIC -Wall -Wextra -pedantic -O3")
    endif()
endif(CMAKE_COMPILER_IS_GNUCC)

add_executable(daemon ${daemon_src})

install(TARGETS daemon
    RUNTIME
    DESTINATION bin)