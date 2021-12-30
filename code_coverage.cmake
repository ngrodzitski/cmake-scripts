# Inspiration
# https://github.com/bilke/cmake-modules/blob/master/CodeCoverage.cmake
# https://gcovr.com/en/stable/guide.html#options
#
# Adds code coverage analysis to all the project starting from a
# given directory. By convention it is assumed that this the directory is a root
# of the project.
# add_code_coverage_targets(
#     NAME
#         prjcoverage                                 # Base name for coverage targets:
#                                                     # prjcoverage_xml
#                                                     # prjcoverage_html
#     FILTERS
#        '${CMAKE_SOURCE_DIR}/my_prj_dir/include/.*'  # Path filters for files
#        '${CMAKE_SOURCE_DIR}/my_prj_dir/src/.*'      # considered for coverage
#     TITLE
#         "My Project report"                         # HTML report page title
# )
function (make_code_coverage_targets)
    #coverage doesn't support ninja build
    if (CMAKE_GENERATOR STREQUAL "Ninja")
        message( FATAL_ERROR "Can not use coverage with ninja" )
    endif()

    set(one_value_args NAME TITLE)
    set(multi_value_args FILTERS)

    cmake_parse_arguments(Coverage "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    find_program_required(
        NAME gcov
        SEARCH_NAME ${TOOLING_CODE_COVERAGE_GCOV_PATH}
        PATH gcov_exe)

    find_program_required(
        NAME gcovr
        SEARCH_NAME ${TOOLING_CODE_COVERAGE_GCOVR}
        PATH gcovr_exe)

    # Instrument our build:
    add_compile_options(-fprofile-arcs -ftest-coverage)
    add_link_options(--coverage -lgcov)

    # Setup target
    add_custom_target(${Coverage_NAME}_ctest_run
        # Run tests
        COMMAND ctest T test
        DEPENDS ${Coverage_DEPENDENCIES}
        COMMENT "Running test to gather coverage data"
    )

    foreach (filt ${Coverage_FILTERS} )
        list(APPEND coverage_filters "-f" ${filt})
    endforeach ()

    message(STATUS "Coverage filters to be used: ${coverage_filters}")

    # -f "'${CMAKE_SOURCE_DIR}/[^/]+/include/.*'"
    # -f "'${CMAKE_SOURCE_DIR}/[^/]+/src/.*'"
    add_custom_target(${Coverage_NAME}_xml
        COMMAND ${gcovr_exe}
                --root ${CMAKE_SOURCE_DIR}
                ${coverage_filters}
                --gcov-executable ${gcov_exe}
                --delete # The gcda files are generated when
                         # the instrumented program is executed.
                         # This flag removes coverage data
                         # so that the next build of the target
                         # collects the date from scratch.
                --xml-pretty
                --print-summary
                --exclude-unreachable-branches
                -o ${CMAKE_SOURCE_DIR}/${Coverage_NAME}.xml
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
        COMMENT "Processing code coverage counters and generating XML report.\n"
    )
    add_dependencies(${Coverage_NAME}_xml ${Coverage_NAME}_ctest_run)


    if (Coverage_TITLE)
        list(APPEND title_args "--html-title" "${Coverage_TITLE}")
    endif()

    add_custom_target(${Coverage_NAME}_html
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SOURCE_DIR}/${Coverage_NAME}
        COMMAND ${gcovr_exe}
                --root ${CMAKE_SOURCE_DIR}
                ${coverage_filters}
                ${title_args}
                --gcov-executable ${gcov_exe}
                --delete # The gcda files are generated when
                         # the instrumented program is executed.
                         # This flag removes coverage data
                         # so that the next build of the target
                         # collects the date from scratch.
                --html --html-details
                --exclude-unreachable-branches
                -o ${CMAKE_SOURCE_DIR}/${Coverage_NAME}/index.html
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
        DEPENDS ${Coverage_DEPENDENCIES}
        COMMENT "Processing code coverage counters and generating HTML report.\n"
    )
    add_dependencies(${Coverage_NAME}_html ${Coverage_NAME}_ctest_run)

    message(STATUS "CODE COVERAGE TARGETS CREATED...\n"
                   "   To build XML code coverage report run:\n"
                   "       cd <build_dir>\n"
                   "       cmake --build . --target ${Coverage_NAME}_xml\n"
                   "   To build HTML code coverage report run:\n"
                   "       cd <build_dir>\n"
                   "       cmake --build . --target ${Coverage_NAME}_html")

    # Show info where to find the report
    add_custom_command(TARGET ${Coverage_NAME}_html POST_BUILD
        COMMAND ;
        COMMENT "Open ${CMAKE_SOURCE_DIR}/${Coverage_NAME}/index.html in your browser to view the coverage report."
    )

    set( add_code_coverage_was_called_flag TRUE )
endfunction ()
