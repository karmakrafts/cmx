if(NOT KSTD_STREAMS_INCLUDED)
    include(CommonLibraries)

    set(KSTD_STREAMS_VERSION master)
    set(KSTD_STREAMS_FETCHED OFF)
    
    macro(target_include_kstd_streams target)
        if(NOT KSTD_STREAMS_FETCHED)
            FetchContent_Declare(
                kstd-streams
                GIT_REPOSITORY https://github.com/karmakrafts/kstd-streams.git
                GIT_TAG ${KSTD_STREAMS_VERSION}
            )
            FetchContent_MakeAvailable(kstd-streams)
            set(KSTD_STREAMS_FETCHED ON)
        endif() # KSTD_STREAMS_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/kstd-streams-src/include")
    endmacro()

    set(KSTD_STREAMS_INCLUDED ON)
endif() # KSTD_STREAMS_INCLUDED
