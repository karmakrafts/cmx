include_guard()

set(CMX_KSTD_STREAMS_VERSION master)
set(CMX_KSTD_STREAMS_FETCHED OFF)

macro(cmx_include_kstd_streams target)
    set(num_args ${ARGC})
    if(num_args GREATER 1)
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
    target_link_libraries(${target} ${access} kstd-streams)
    add_dependencies(${target} kstd-streams)
endmacro()