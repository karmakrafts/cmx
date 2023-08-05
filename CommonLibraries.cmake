if(NOT COMMON_LIBRARIES_INCLUDED)
    include(FetchContent)
    include(Platform)
    set(CL_DEPS_DIR "${CMAKE_CURRENT_BINARY_DIR}/_deps")

    # CMake Scripts
    set(CL_SCRIPTS_VERSION 23.06)
    set(CL_SCRIPTS_FETCHED OFF)

    macro(include_scripts)
        if(NOT CL_SCRIPTS_FETCHED)
            FetchContent_Declare(
                cmake-scripts
                GIT_REPOSITORY https://github.com/StableCoder/cmake-scripts.git
                GIT_TAG ${CL_SCRIPTS_VERSION})
            FetchContent_Populate(cmake-scripts)
            set(CL_SCRIPTS_FETCHED ON)
        endif() # CL_SCRIPTS_FETCHED

        set(CMAKE_MODULE_PATH "${CL_DEPS_DIR}/cmake-scripts-src;")
        set(ENABLE_ALL_WARNINGS ON)

        include(compiler-options)

        if (NOT COMPILER_MSVC AND NOT (PLATFORM_WINDOWS AND COMPILER_CLANG))
            if(${BUILD_DEBUG})
                set(USE_SANITIZER Thread,Undefined)
            else() # BUILD_DEBUG
                set(USE_SANITIZER "")
            endif() # BUILD_DEBUG
            include(sanitizers)
        endif () # COMPILER_MSVC
    endmacro()

    # GoogleTest
    set(CL_GTEST_VERSION 1.13.0)
    set(CL_GTEST_FETCHED OFF)

    macro(target_include_gtest target)
        set(gtest_force_shared_crt OFF CACHE BOOL "" FORCE)

        if(NOT CL_GTEST_FETCHED)
            FetchContent_Declare(
                googletest
                GIT_REPOSITORY https://github.com/google/googletest.git
                GIT_TAG "v${CL_GTEST_VERSION}")
            FetchContent_MakeAvailable(googletest)
            set(CL_GTEST_FETCHED ON)
        endif() # CL_GTEST_FETCHED

        enable_testing(TRUE)
        include(GoogleTest)
        gtest_discover_tests(${target})
        target_link_libraries(${target} PUBLIC gtest_main)
    endmacro()
    
    # {fmt}
    set(CL_FMT_VERSION 10.0.0)
    set(CL_FMT_FETCHED OFF)
    
    macro(target_include_fmt target)
        if(NOT CL_FMT_FETCHED)
            FetchContent_Declare(
                fmt
                GIT_REPOSITORY https://github.com/fmtlib/fmt.git
                GIT_TAG ${CL_FMT_VERSION}
            )
            FetchContent_MakeAvailable(fmt)
            set(CL_FMT_FETCHED ON)
        endif() # CL_FMT_FETCHED

        target_compile_definitions(${target} PUBLIC
            FMT_HEADER_ONLY=1
            FMT_EXCEPTIONS=0
            FMT_NOEXCEPT=1)
        target_include_directories(${target} PUBLIC ${CL_DEPS_DIR}/fmt-src/include)
    endmacro()
    
    # parallel_hashmap
    set(CL_PHMAP_VERSION 1.3.11)
    set(CL_PHMAP_FETCHED OFF)
    
    macro(target_include_phmap target)
        if(NOT CL_PHMAP_FETCHED)
            FetchContent_Declare(
                phmap
                GIT_REPOSITORY https://github.com/greg7mdp/parallel-hashmap.git
                GIT_TAG "v${CL_PHMAP_VERSION}"
            )
            FetchContent_MakeAvailable(phmap)
            set(CL_PHMAP_FETCHED ON)
        endif() # CL_PHMAP_FETCHED

        target_compile_definitions(${target} PUBLIC _SILENCE_CXX23_ALIGNED_STORAGE_DEPRECATION_WARNING)
        target_include_directories(${target} PUBLIC ${CL_DEPS_DIR}/phmap-src)
    endmacro()

    set(COMMON_LIBRARIES_INCLUDED ON)
endif() # COMMON_LIBRARIES_INCLUDED
