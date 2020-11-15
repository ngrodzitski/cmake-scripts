# Append sources to given targets (list-variables).
#
# append_src_files(
#     TARGET
#       prj_x_src_group1                    # A target list containing sources.
#       prj_x_src_group2                    # Another target list containing sources.
#     GLOB_PATTERN                          # Glob file search pattarn.
#                  include/projectX/*.hpp
#                  include/projectX/*.inl
# )
#
# Effectively does the same as the following sequence of commands:
#     file(GLOB tmp_headers_1 include/projectX/*.hpp)
#     file(GLOB tmp_headers_2 include/projectX/*.inl)
#     list(APPEND prj_x_src_group1 ${tmp_headers_1} ${tmp_headers_2})
#     list(APPEND prj_x_src_group2 ${tmp_headers_1} ${tmp_headers_2})
#
# Handling multiple target variables sometimes helpfull in cases
# there are public source files and private.
# And one of the target list-variables wil be used for install description
# and another one will be used for building target.
function(append_src_files)

    set(multi_value_args TARGET GLOB_PATTERN )
    cmake_parse_arguments(asf_arg "${options}" "" "${multi_value_args}" ${ARGN})

    if(NOT asf_arg_TARGET)
        message(FATAL_ERROR "TARGET argument missing for `append_src_files()` function")
    endif()
    if(NOT asf_arg_GLOB_PATTERN)
        message(FATAL_ERROR "GLOB_PATTERN argument missing for `append_src_files()` function")
    endif()

    foreach ( pattern ${asf_arg_GLOB_PATTERN} )
        file(GLOB source_files ${pattern})
        list(APPEND all_source_files ${source_files})
    endforeach ()

    if(asf_arg_SOURCE_GROUP)
        source_group(${asf_arg_SOURCE_GROUP} FILES ${all_source_files})
    endif()

    foreach ( target ${asf_arg_TARGET} )
        set(output_source_files ${${target}})
        list(APPEND output_source_files ${all_source_files})
        set(${target} ${output_source_files} PARENT_SCOPE)
    endforeach ()

endfunction()
