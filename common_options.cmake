include(CMakeDependentOption)

#
# Compiler warnings
#

option(
    COMPILER_ENABLE_ALL_WARNINGS "Enable compiler warnings."
    ON)

option(
    COMPILER_ENABLE_UNUSED_X_AS_ERROR "Enable compiler unused x errors."
    ON)

option(
    COMPILER_ENABLE_EFFECTIVE_CXX "Enable effective C++ warnings."
    OFF) # Too noisy - disable by default.

#
# CPPCHECk
#

option(
    TOOLING_ENABLE_CPPCHECK "Enable static analysis with cppcheck."
    OFF)

if(TOOLING_ENABLE_CPPCHECK)
    if(NOT TOOLING_CPPCHECK_PATH)
        set(TOOLING_CPPCHECK_PATH "cppcheck")
    endif()

    if(NOT TOOLING_CPPCHECK_PARAMS)
        set(TOOLING_CPPCHECK_PARAMS
            "--enable=warning,performance,portability,missingInclude"
            "--template=[CPPCHECK][{severity}][{id}] {message} {callstack} \(On {file}:{line}\)"
            "--suppress=missingIncludeSystem"
            "--quiet"
            "--verbose"
            "--force" )
    endif()
endif()

#
# CLANG-TIDY
#

option(
    TOOLING_ENABLE_CLANG_TIDY "Enable static analysis with clang-tidy."
    OFF)

if(TOOLING_ENABLE_CLANG_TIDY)
    if(NOT TOOLING_CLANG_TIDY_PATH)
        set(TOOLING_CLANG_TIDY_PATH "clang-tidy")
    endif()
    if(NOT TOOLING_CLANG_TIDY_PARAMS)
        set(TOOLING_CLANG_TIDY_PARAMS
            "-checks=*,-cppcoreguidelines-pro-type-vararg,-fuchsia-default-arguments-calls,-hicpp-vararg,-llvm-include-order,-fuchsia-overloaded-operator,-cert-err58-cpp,-modernize-use-trailing-return-type"
            "-header-filter='${CMAKE_SOURCE_DIR}/*'"
            "-warnings-as-errors='*'" )
    endif()
endif()
