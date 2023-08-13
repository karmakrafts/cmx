if(NOT CMX_DAWN_INCLUDED)
    set(CMX_DAWN_VERSION master)
    set(CMX_DAWN_FETCHED OFF)
    
    macro(cmx_include_dawn target)
        set(num_args ${ARGC})
        if(num_args GREATER 1)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_DAWN_FETCHED)
            FetchContent_Declare(
                dawn
                GIT_REPOSITORY https://dawn.googlesource.com/dawn.git
                GIT_TAG ${CMX_DAWN_VERSION}
            )
            FetchContent_MakeAvailable(dawn)
            set(CMX_DAWN_FETCHED ON)
        endif() # CMX_DAWN_FETCHED

        target_include_directories(${target} ${access} "${dawn_SOURCE_DIR}/include")
    endmacro()

    set(CMX_DAWN_INCLUDED ON)
endif() # CMX_DAWN_INCLUDED
