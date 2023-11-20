function(extract_version
    version_file_path
    major_varname
    minor_varname
    patch_varname)

    file(READ "${version_file_path}" version_hpp)

    string(REGEX MATCH "VERSION_MAJOR ([0-9]+)ull" MATCHED_CONTENT ${version_hpp})

    if(MATCHED_CONTENT)
        set(version_major ${CMAKE_MATCH_1})
    else()
        message(FATAL_ERROR "Failed to extract *_VERSION_MAJOR from ${version_file_path}")
    endif()

    string(REGEX MATCH "VERSION_MINOR ([0-9]+)ull" MATCHED_CONTENT ${version_hpp})

    if(MATCHED_CONTENT)
        set(version_minor ${CMAKE_MATCH_1})
    else()
        message(FATAL_ERROR "Failed to extract *_VERSION_MINOR from ${version_file_path}")
    endif()

    string(REGEX MATCH "VERSION_PATCH ([0-9]+)ull" MATCHED_CONTENT ${version_hpp})

    if(MATCHED_CONTENT)
        set(version_patch ${CMAKE_MATCH_1})
    else()
        message(FATAL_ERROR "Failed to extract *_VERSION_PATCH from ${version_file_path}")
    endif()


    set(${major_varname} ${version_major} PARENT_SCOPE)
    set(${minor_varname} ${version_minor} PARENT_SCOPE)
    set(${patch_varname} ${version_patch} PARENT_SCOPE)

    message(STATUS "extract_version(${version_file_path}) "
                   "${version_major}.${version_minor}.${version_patch}"
   )

endfunction()
