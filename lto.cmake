# Apply LTO via global compiler flags if necessary.
macro (handle_lto_if_necessary)
    if (EXPLICIT_BUILD_WITH_LTO)
        if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
            include(CheckIPOSupported)
            check_ipo_supported(RESULT ipo_supported)

            if (ipo_supported)
                include(ProcessorCount)
                ProcessorCount(cpu_count)
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -flto=${cpu_count} -fno-fat-lto-objects")
                set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -flto=${cpu_count} -fno-fat-lto-objects")
            endif ()
        else ()
            set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
        endif ()
    endif ()
endmacro ()

