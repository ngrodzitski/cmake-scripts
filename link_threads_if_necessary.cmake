function(link_threads_if_necessary target_name)
    set(THREADS_PREFER_PTHREAD_FLAG ON)

    find_package(Threads)
    # target_link_libraries(my_app Threads::Threads)
    if(Threads_FOUND)
        target_link_libraries(${target_name} PRIVATE Threads::Threads)
    endif()
endfunction(link_threads_if_necessary)
