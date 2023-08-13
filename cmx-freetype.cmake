if(NOT CMX_FREETYPE_INCLUDED)
    set(CMX_FREETYPE_VERSION main)
    set(CMX_FREETYPE_FETCHED OFF)
    
    macro(cmx_include_freetype target)
        set(num_args ${ARGC})
        if(num_args GREATER 1)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_FREETYPE_FETCHED)
            FetchContent_Declare(
                freetype
                GIT_REPOSITORY https://github.com/freetype/freetype.git
                GIT_TAG ${CMX_FREETYPE_VERSION}
            )
            FetchContent_MakeAvailable(freetype)
            set(CMX_FREETYPE_FETCHED ON)
        endif() # CMX_FREETYPE_FETCHED

        target_link_libraries(${target} ${access} freetype)
        add_dependencies(${target} freetype)
    endmacro()

    set(CMX_FREETYPE_INCLUDED ON)
endif() # CMX_FREETYPE_INCLUDED
