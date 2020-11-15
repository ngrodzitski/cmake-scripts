if(NOT UNITTEST)
    message(FATAL_ERROR "UNITTEST is not defined!")
endif()

if(NOT UNITTEST_SRCFILES)
    # If no explicit sourcefile list, then assume `main.cpp`.
    set(UNITTEST_SRCFILES main.cpp)
endif()

add_executable(${UNITTEST} ${UNITTEST_SRCFILES})

if(WIN32)
    target_compile_definitions(${UNITTEST} PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

target_link_libraries(${UNITTEST} PRIVATE gtest::gtest)

# GTest::Main deals with pthread by itself.
# link_threads_if_necessary(${UNITTEST})

# This integrates itself better for CI test discovery:
# https://cmake.org/cmake/help/v3.15/module/GoogleTest.html?#command:gtest_discover_tests

include(GoogleTest)

if(USER_GTEST_TEST_PREFIX)
    # USER_GTEST_TEST_PREFIX can be specified on CI builds to make test
    # names unique for different targets (os+compiler)
    # In general any build can be assigned a unique test prefix
    # to distinguish its test.
    gtest_discover_tests(${UNITTEST} TEST_PREFIX ${USER_GTEST_TEST_PREFIX} )
else ()
    # No test prefix is specified. This is a "default" option
    # for developers build.
    gtest_discover_tests(${UNITTEST})
endif()
