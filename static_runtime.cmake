# TODO:
# Revisit this scrip, it's likely can be hand;ed with Conan profiles.
macro(handle_explicit_static_runtime_if_necessary)
    if(EXPLICIT_STATIC_RUNTIME)
        message(STATUS "Using static runtime (EXPLICIT_STATIC_RUNTIME is enabled)")

        if (MSVC)
            set(compiler_flags
                CMAKE_CXX_FLAGS
                CMAKE_CXX_FLAGS_DEBUG
                CMAKE_CXX_FLAGS_RELEASE
                CMAKE_CXX_FLAGS_RELWITHDEBINFO
                CMAKE_CXX_FLAGS_MINSIZEREL
                CMAKE_C_FLAGS
                CMAKE_C_FLAGS_DEBUG
                CMAKE_C_FLAGS_RELEASE
                CMAKE_C_FLAGS_RELWITHDEBINFO
                CMAKE_C_FLAGS_MINSIZEREL)

            foreach(cflag ${compiler_flags})
                set(before_flags ${${cflag}} )
                string(REPLACE "/MD" "/MT" ${cflag} "${${cflag}}")
                message(STATUS "Change ${cflag}: [${before_flags}] => [${${cflag}}]")
            endforeach()
        else ()
            set(CMAKE_EXE_LINKER_FLAGS "-static")
            message(STATUS "CMAKE_EXE_LINKER_FLAGS += -static")
        endif ()
    endif ()
endmacro()
