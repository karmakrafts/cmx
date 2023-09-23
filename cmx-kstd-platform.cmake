include_guard()

set(CMX_KSTD_PLATFORM_VERSION master)
set(CMX_KSTD_PLATFORM_FETCHED OFF)

macro(cmx_include_kstd_platform target)
    set(num_args ${ARGC})
    if(num_args GREATER 1)
        set(access ${ARGV1}) # Copy first optional argument
    else()
        set(access PUBLIC) # Default to PUBLIC
    endif()
    if(NOT CMX_KSTD_PLATFORM_FETCHED)
        FetchContent_Declare(
            kstd-platform
            GIT_REPOSITORY https://github.com/karmakrafts/kstd-platform.git
            GIT_TAG ${CMX_KSTD_PLATFORM_VERSION}
        )
        FetchContent_MakeAvailable(kstd-platform)
        set(CMX_KSTD_PLATFORM_FETCHED ON)
    endif() # CMX_KSTD_PLATFORM_FETCHED
    target_link_libraries(${target} ${access} kstd-platform-static)
    add_dependencies(${target} kstd-platform-static)
endmacro()