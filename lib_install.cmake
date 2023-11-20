cmake_minimum_required(VERSION 3.20)

# lib_install(
#     # The name of the project
#     TARGET_PROJECT <str>
#
#     # List of targets to install.
#     # If the argumnt is omitted then the default value is "${TARGET_PROJECT}".
#     [TARGETS_LIST <target1>[;<target2>...]]
#
#     # Define the version of the library/package.
#     VERSION <path>
#
#     # Template for lib config file.
#     LIB_CONFIG <path>
#
#     # Compatibility mode (optional, default: SameMinorVersion).
#     [LIB_COMPATIBILITY <path>]
# )
function(lib_install)
    set(one_value_args
        TARGET_PROJECT
        LIB_CONFIG
        VERSION
        LIB_COMPATIBILITY
    )

    set(multi_value_args TARGETS_LIST)

    cmake_parse_arguments(lib_install "${options}"
                                      "${one_value_args}"
                                      "${multi_value_args}"
                                      ${ARGN}
    )

    message(STATUS "====================================")
    message(STATUS "PREPARING INSTALL OF LIBRARY PROJECT")
    message(STATUS "TARGET_PROJECT=${lib_install_TARGET_PROJECT}")
    message(STATUS "LIB_CONFIG=${lib_install_LIB_CONFIG}")
    message(STATUS "VERSION=${lib_install_VERSION}")
    message(STATUS "LIB_COMPATIBILITY=${lib_install_LIB_COMPATIBILITY}")

    if (NOT lib_install_TARGET_PROJECT)
        message(FATAL_ERROR "TARGET_PROJECT parameter must be defined")
    endif ()

    if (NOT lib_install_TARGETS_LIST)
        set(lib_install_TARGETS_LIST ${lib_install_TARGET_PROJECT})
        message(STATUS "TARGETS_LIST=${lib_install_TARGETS_LIST} (auto deduced)")
    else ()
        message(STATUS "TARGETS_LIST=${lib_install_TARGETS_LIST}")
    endif ()

    if (NOT lib_install_LIB_CONFIG)
        message(FATAL_ERROR "LIB_CONFIG parameter must be defined")
    endif ()

    if (NOT lib_install_LIB_COMPATIBILITY)
        set(lib_install_LIB_COMPATIBILITY SameMinorVersion)
    endif ()

    include(GNUInstallDirs)
    include(CMakePackageConfigHelpers)

    set(cmake_destination ${CMAKE_INSTALL_LIBDIR}/cmake/${lib_install_TARGET_PROJECT})

    install(TARGETS ${lib_install_TARGETS_LIST}
        EXPORT ${lib_install_TARGET_PROJECT}_project_targets
    )

    install(EXPORT ${lib_install_TARGET_PROJECT}_project_targets
      FILE ${lib_install_TARGET_PROJECT}_targets.cmake
      NAMESPACE ${lib_install_TARGET_PROJECT}::
      DESTINATION ${cmake_destination}
    )

set(tmp_version_config ${PROJECT_BINARY_DIR}/${lib_install_TARGET_PROJECT}-config-version.cmake)
set(tmp_project_config ${PROJECT_BINARY_DIR}/${lib_install_TARGET_PROJECT}-config.cmake)

configure_package_config_file(${lib_install_LIB_CONFIG}
    ${tmp_project_config}
    INSTALL_DESTINATION ${cmake_destination}
)

write_basic_package_version_file(
    ${tmp_version_config}
    VERSION ${lib_install_VERSION}
    COMPATIBILITY ${lib_install_LIB_COMPATIBILITY}
)

# Install version, config and target files.
install(FILES ${tmp_version_config} ${tmp_project_config}
    DESTINATION ${cmake_destination}
)
endfunction()

# lib_install_headers(
#     # The path-prefix that must be removed from all headers to install.
#     REMOVE_INCLUDE_DIR_PREFIX <str>
#
#     # List of targets to install.
#     TARGETS_LIST <target1>[;<target2>...]
#
#     # Define the version of the library/package.
#     VERSION <path>
#
#     # Template for lib config file.
#     LIB_CONFIG <path>
#
#     # Compatibility mode (optional, default: SameMinorVersion).
#     [LIB_COMPATIBILITY <path>]
# )
function(lib_install_headers)
    set(one_value_args REMOVE_INCLUDE_DIR_PREFIX)
    set(multi_value_args HEADERS)

    cmake_parse_arguments(lib_install_headers "${options}"
                                              "${one_value_args}"
                                              "${multi_value_args}"
                                              ${ARGN})
    message(STATUS "=====================================")
    message(STATUS "PREPARING INSTALL FOR HEADERS")
    message(STATUS "REMOVE_INCLUDE_DIR_PREFIX=${lib_install_headers_REMOVE_INCLUDE_DIR_PREFIX}")
    message(STATUS "HEADERS=${lib_install_headers_HEADERS}")

    foreach (header ${lib_install_headers_HEADERS} )

        message(STATUS "for: ${header}")

        if(IS_ABSOLUTE "${header}")
            if(NOT IS_ABSOLUTE "${lib_install_headers_REMOVE_INCLUDE_DIR_PREFIX}")
                message(FATAL_ERROR "HEADERS values and REMOVE_INCLUDE_DIR_PREFIX "
                                    "must both be either absolute or relative")
            endif()
            file(RELATIVE_PATH
                header_path
                ${lib_install_headers_REMOVE_INCLUDE_DIR_PREFIX}
                ${header}
            )
        else ()
            if(IS_ABSOLUTE "${lib_install_headers_REMOVE_INCLUDE_DIR_PREFIX}")
                message(FATAL_ERROR "HEADERS values and REMOVE_INCLUDE_DIR_PREFIX "
                                    "must both be either absolute or relative")
            endif()

            # We must provide absolute path for `file(RELATIVE_PATH ...)`
            # to work, so we just take CMAKE_CURRENT_SOURCE_DIR to construct absolute
            # path values.
            file(RELATIVE_PATH
                header_path
                ${CMAKE_CURRENT_SOURCE_DIR}/${lib_install_headers_REMOVE_INCLUDE_DIR_PREFIX}
                ${CMAKE_CURRENT_SOURCE_DIR}/${header}
            )
        endif ()
        get_filename_component(relative_to_include_dir ${header_path} PATH )

        message(STATUS "for*: ${relative_to_include_dir}")

        install( FILES ${header}
                 DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${relative_to_include_dir} )
    endforeach ()
endfunction()
