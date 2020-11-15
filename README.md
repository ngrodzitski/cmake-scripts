# cmake-scipts

A collection of cmake-scripts with common routines used for cmake-based projects.

## CMake scripts practical rules

A quick memo of usefull rules (treat it as "SHOULD BETTER", not "MUST").

 * Use modern CMake (e.g. not older than a year). So it would be possible to introduce new usefull features.
 * Discourage the use of global settings (e.g. [include_directories](https://cmake.org/cmake/help/latest/command/include_directories.html#command:include_directories)/[link_directories](https://cmake.org/cmake/help/v3.0/command/link_directories.html) dirs).
 * Set dependencies with [target_link_libraries](https://cmake.org/cmake/help/latest/command/target_link_libraries.html?highlight=target_link_libraries).
 * Discourage essential decisions made in script (e.g. conditional functionality or dependencies must not be based on somethig like the following: "well I see a boost in a system so I can depend on it and enable a certain functionality". Decision that are based on variables passed to cmake are preferable: -DENABLE_MY_BOOST_STUFF=ON).
 * Compiler flags can be set only in root CMake-script, this makes them usable in another type of builds (e.g. for sanitizers or static runtime options). If flags MUST be set (consider benchmarks targets) the reason why must be clarified in comments (who/why) in order to leave a hint for a reader in case of troubles.
 * Root CMake-script must define no targets. It is only for setting compiler flags, resolving dependencies ([find_package](https://cmake.org/cmake/help/latest/command/find_package.html?highlight=find_package)(necessary_lib 1.2.3)) and gathering meaningful targets (add_subdirectory("project/to/build")).
 * Use namespaces ([why](https://gist.github.com/mbinna/c61dbb39bca0e4fb7d1f73b0d66a4fd1#using-a-library-defined-in-the-same-cmake-tree-should-look-the-same-as-using-an-external-library)).
 * Define install targets or at least think of it (the other day you might find yourself need to install your application).

## Reference

* https://gist.github.com/mbinna/c61dbb39bca0e4fb7d1f73b0d66a4fd1#using-a-library-defined-in-the-same-cmake-tree-should-look-the-same-as-using-an-external-library
* https://www.youtube.com/watch?v=bsXLMQ6WgIk C++Now 2017: Daniel Pfeifer “Effective CMake"
* https://www.youtube.com/watch?v=eC9-iRN2b04 CppCon 2017: Mathieu Ropert “Using Modern CMake Patterns to Enforce a Good Modular Design”

## License

[License](./LICENSE)-unlicense.
