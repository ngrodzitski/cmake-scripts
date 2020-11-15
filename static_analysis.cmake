# Adds code maintenance improvements.
# Source of inspiration:
# https://blog.kitware.com/static-checks-with-cmake-cdash-iwyu-clang-tidy-lwyu-cpplint-and-cppcheck/

if(TOOLING_ENABLE_CPPCHECK)
    find_program_required(
        NAME cppcheck
        SEARCH_NAME ${TOOLING_CPPCHECK_PATH}
        PATH cppcheck_exe)

  set(CMAKE_CXX_CPPCHECK "${cppcheck_exe};${TOOLING_CPPCHECK_PARAMS}")

  # Rely on CMake feature:
  # https://cmake.org/cmake/help/v3.10/variable/CMAKE_LANG_CPPCHECK.html#variable:CMAKE_%3CLANG%3E_CPPCHECK
  message(STATUS "CMAKE_CXX_CPPCHECK: ${CMAKE_CXX_CPPCHECK}")
endif()

if(TOOLING_ENABLE_CLANG_TIDY)
  find_program_required(
    NAME clang-tidy
    SEARCH_NAME ${TOOLING_CLANG_TIDY_PATH}
    PATH clang_tidy_exe )

  # Rely on CMake feature:
  # https://cmake.org/cmake/help/v3.10/variable/CMAKE_LANG_CLANG_TIDY.html#variable:CMAKE_%3CLANG%3E_CLANG_TIDY
  set(CMAKE_CXX_CLANG_TIDY "${clang_tidy_exe};${TOOLING_CLANG_TIDY_PARAMS}")
  message(STATUS "CMAKE_CXX_CLANG_TIDY: ${CMAKE_CXX_CLANG_TIDY}")
endif()
