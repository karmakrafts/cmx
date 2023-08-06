if(NOT CMX_ZLIB_INCLUDED)
    set(CMX_ZLIB_VERSION master)
    set(CMX_ZLIB_FETCHED OFF)
    
    macro(cmx_include_zlib target)
        set(num_args ${ARGC})
        if(num_args GREATER 0)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_ZLIB_FETCHED)
            FetchContent_Declare(
                zlib
                GIT_REPOSITORY https://github.com/madler/zlib.git
                GIT_TAG ${CMX_ZLIB_VERSION}
            )
            FetchContent_MakeAvailable(zlib)
            set(CMX_ZLIB_FETCHED ON)
        endif() # CMX_ZLIB_FETCHED

        target_include_directories(${target} ${access} ${zlib_SOURCE_DIR})
        target_link_libraries(${target} ${access} zlibstatic)
        add_dependencies(${target} zlibstatic)
    endmacro()

    set(CMX_ZLIB_INCLUDED ON)
endif() # CMX_ZLIB_INCLUDED
