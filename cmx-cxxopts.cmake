if(NOT CMX_CXXOPTS_INCLUDED)
    set(CMX_CXXOPTS_VERSION master)
    set(CMX_CXXOPTS_FETCHED OFF)
    
    macro(cmx_include_cxxopts target)
        set(num_args ${ARGC})
        if(num_args GREATER 1)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_CXXOPTS_FETCHED)
            FetchContent_Declare(
                cxxopts
                GIT_REPOSITORY https://github.com/jarro2783/cxxopts.git
                GIT_TAG ${CMX_CXXOPTS_VERSION}
            )
            FetchContent_MakeAvailable(cxxopts)
            set(CMX_CXXOPTS_FETCHED ON)
        endif() # CMX_CXXOPTS_FETCHED

        target_link_libraries(${target} ${access} cxxopts)
        add_dependencies(${target} cxxopts)
    endmacro()

    set(CMX_CXXOPTS_INCLUDED ON)
endif() # CMX_CXXOPTS_INCLUDED
