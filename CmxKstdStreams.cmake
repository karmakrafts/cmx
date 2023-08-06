if(NOT CMX_KSTD_STREAMS_INCLUDED)
    set(CMX_KSTD_STREAMS_VERSION master)
    set(CMX_KSTD_STREAMS_FETCHED OFF)
    
    macro(target_include_kstd_streams target)
        set(num_args ${ARGC})
        if(num_args GREATER 0)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_KSTD_STREAMS_FETCHED)
            FetchContent_Declare(
                kstd-streams
                GIT_REPOSITORY https://github.com/karmakrafts/kstd-streams.git
                GIT_TAG ${CMX_KSTD_STREAMS_VERSION}
            )
            FetchContent_MakeAvailable(kstd-streams)
            set(CMX_KSTD_STREAMS_FETCHED ON)
        endif() # CMX_KSTD_STREAMS_FETCHED

        target_include_directories(${target} ${access} "${kstd-streams_SOURCE_DIR}/include")
    endmacro()

    set(CMX_KSTD_STREAMS_INCLUDED ON)
endif() # CMX_KSTD_STREAMS_INCLUDED