if(NOT ZLIB_INCLUDED)
    include(CommonLibraries)

    set(ZLIB_VERSION master)
    set(ZLIB_FETCHED OFF)
    
    macro(target_include_zlib target)
        if(NOT ZLIB_FETCHED)
            FetchContent_Declare(
                zlib
                GIT_REPOSITORY https://github.com/madler/zlib.git
                GIT_TAG ${ZLIB_VERSION}
            )
            FetchContent_MakeAvailable(zlib)
            set(ZLIB_FETCHED ON)
        endif() # ZLIB_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/zlib-src")
        target_link_libraries(${target} PUBLIC zlib::zlibstatic)
        add_dependencies(${target} zlib::zlibstatic)
    endmacro()

    set(ZLIB_INCLUDED ON)
endif() # ZLIB_INCLUDED
