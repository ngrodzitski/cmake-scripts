# OBSOLETE
# For conan-based projects with conan v2 one can rely on toolchain file
# to set the libcxx as necessary (acording the one used in `conan install ...` command,
# either it is set explicitly: `-s:a compiler.libcxx=libstdc++` or implicitly in profile
# or defaults).
macro(handle_explicit_libcxx_if_necessary)
    if(EXPLICIT_LIBCXX)
        message(STATUS "Using libcxx: ${EXPLICIT_LIBCXX}")
        message(STATUS "Using libcxx: CMAKE_CXX_COMPILER_ID=${CMAKE_CXX_COMPILER_ID}")

        if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
            if(EXPLICIT_LIBCXX STREQUAL "libstdc++" OR EXPLICIT_LIBCXX STREQUAL "libstdc++11" )
                message(STATUS "libcxx adjustment: CMAKE_CXX_FLAGS += '-stdlib=libstdc++'")
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libstdc++")
            elseif(EXPLICIT_LIBCXX STREQUAL "libc++")
                message(STATUS "libcxx adjustment: CMAKE_CXX_FLAGS += '-stdlib=libc++'")
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
                message(STATUS "libcxx adjustment: CMAKE_EXE_LINKER_FLAGS += '-stdlib=libc++'")
                set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++")
            endif()
        endif()

        if(EXPLICIT_LIBCXX STREQUAL "libstdc++11")
            message(STATUS "libcxx adjustment: -D_GLIBCXX_USE_CXX11_ABI=1")
            add_definitions(-D_GLIBCXX_USE_CXX11_ABI=1)
        elseif(EXPLICIT_LIBCXX STREQUAL "libstdc++")
            message(STATUS "libcxx adjustment: -D_GLIBCXX_USE_CXX11_ABI=0")
            add_definitions(-D_GLIBCXX_USE_CXX11_ABI=0)
        endif()
    endif()
endmacro()
