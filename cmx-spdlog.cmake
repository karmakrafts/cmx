if(NOT CMX_SPDLOG_INCLUDED)
    set(CMX_SPDLOG_VERSION "v1.12.0")
    set(CMX_SPDLOG_FETCHED OFF)
    
    macro(cmx_include_spdlog target)
        set(num_args ${ARGC})
        if(num_args GREATER 1)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_SPDLOG_FETCHED)
            FetchContent_Declare(
                spdlog
                GIT_REPOSITORY https://github.com/gabime/spdlog.git
                GIT_TAG ${CMX_SPDLOG_VERSION}
            )
            FetchContent_MakeAvailable(spdlog)
            set(CMX_SPDLOG_FETCHED ON)
        endif() # CMX_SPDLOG_FETCHED

        target_link_libraries(${target} ${access} spdlog)
        add_dependencies(${target} spdlog)
    endmacro()

    set(CMX_SPDLOG_INCLUDED ON)
endif() # CMX_SPDLOG_INCLUDED
