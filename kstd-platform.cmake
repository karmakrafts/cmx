set(CL_KSTD_PLATFORM_VERSION master)

macro(target_include_kstd_platform target)
    FetchContent_Declare(
        kstd-platform
        GIT_REPOSITORY https://github.com/karmakrafts/kstd-platform.git
        GIT_TAG ${CL_KSTD_PLATFORM_VERSION}
    )
    FetchContent_MakeAvailable(kstd-platform)
    target_include_directories(${target} PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/_deps/kstd-platform-src/include")
endmacro()
