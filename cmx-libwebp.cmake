if(NOT CMX_LIBWEBP_INCLUDED)
    set(CMX_LIBWEBP_VERSION main)
    set(CMX_LIBWEBP_FETCHED OFF)
    
    macro(cmx_include_libwebp target)
        set(num_args ${ARGC})
        if(num_args GREATER 1)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_LIBWEBP_FETCHED)
            FetchContent_Declare(
                libwebp
                GIT_REPOSITORY https://github.com/webmproject/libwebp.git
                GIT_TAG ${CMX_LIBWEBP_VERSION}
            )
            FetchContent_MakeAvailable(libwebp)
            set(CMX_LIBWEBP_FETCHED ON)
        endif() # CMX_LIBWEBP_FETCHED

        target_link_libraries(${target} ${access} webp)
        add_dependencies(${target} webp)
    endmacro()

    set(CMX_LIBWEBP_INCLUDED ON)
endif() # CMX_LIBWEBP_INCLUDED
