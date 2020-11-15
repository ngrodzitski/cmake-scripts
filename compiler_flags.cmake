if(COMPILER_ENABLE_ALL_WARNINGS)
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
        set(gcc_warnings_flags  -Wall
                                -Wextra
                                -Wpedantic
                                -Werror=unused-function
                                -Werror=unused-variable
                                -Werror=unused-parameter)

        message(STATUS "Enable compiler warnings: ${gcc_warnings_flags}")
        # gcc/clang
        add_compile_options(${gcc_warnings_flags})
    elseif(MSVC)
        # msvc
        string(REGEX REPLACE " /W[0-4]" "" CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
        string(REGEX REPLACE " /W[0-4]" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
        add_compile_options(/W4)
    endif()
endif()

if(COMPILER_ENABLE_UNUSED_X_AS_ERROR)
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
        set(gcc_error_flags -Werror=unused-function
                            -Werror=unused-variable
                            -Werror=unused-parameter)

        message(STATUS "Enable compiler errors: ${gcc_error_flags}")
        # gcc/clang
        add_compile_options(${gcc_error_flags})
    endif()
endif()

if(COMPILER_ENABLE_EFFECTIVE_CXX)
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
        message(STATUS "Enable Effective C++ warnings")
        # gcc/clang
        add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-Weffc++>)
    else()
        # Not supported
        message(WARNING "COMPILER_ENABLE_EFFECTIVE_CXX is not supported")
    endif()
endif()
