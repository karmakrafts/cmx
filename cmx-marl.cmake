if(NOT CMX_MARL_INCLUDED)
    set(CMX_MARL_VERSION master)
    set(CMX_MARL_FETCHED OFF)
    
    macro(cmx_include_marl target)
        set(num_args ${ARGC})
        if(num_args GREATER 1)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_MARL_FETCHED)
            FetchContent_Declare(
                marl
                GIT_REPOSITORY https://github.com/google/marl.git
                GIT_TAG ${CMX_MARL_VERSION}
            )
            FetchContent_MakeAvailable(marl)
            set(CMX_MARL_FETCHED ON)
        endif() # CMX_MARL_FETCHED

        target_include_directories(${target} ${access} "${marl_SOURCE_DIR}/include")
    endmacro()

    set(CMX_MARL_INCLUDED ON)
endif() # CMX_MARL_INCLUDED
