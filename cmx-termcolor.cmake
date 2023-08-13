if(NOT CMX_TERMCOLOR_INCLUDED)
    set(CMX_TERMCOLOR_VERSION master)
    set(CMX_TERMCOLOR_FETCHED OFF)
    
    macro(cmx_include_termcolor target)
        set(num_args ${ARGC})
        if(num_args GREATER 1)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_TERMCOLOR_FETCHED)
            FetchContent_Declare(
                termcolor
                GIT_REPOSITORY https://github.com/ikalnytskyi/termcolor.git
                GIT_TAG ${CMX_TERMCOLOR_VERSION}
            )
            FetchContent_MakeAvailable(termcolor)
            set(CMX_TERMCOLOR_FETCHED ON)
        endif() # CMX_TERMCOLOR_FETCHED

        target_link_libraries(${target} ${access} termcolor)
        add_dependencies(${target} termcolor)
    endmacro()

    set(CMX_TERMCOLOR_INCLUDED ON)
endif() # CMX_TERMCOLOR_INCLUDED
