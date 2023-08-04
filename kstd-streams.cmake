set(CL_KSTD_STREAMS_VERSION master)

macro(target_include_kstd_streams target)
    FetchContent_Declare(
        kstd-streams
        GIT_REPOSITORY https://github.com/karmakrafts/kstd-streams.git
        GIT_TAG ${CL_KSTD_STREAMS_VERSION}
    )
    FetchContent_MakeAvailable(kstd-streams)
    target_include_directories(${target} PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/_deps/kstd-streams-src/include")
endmacro()
