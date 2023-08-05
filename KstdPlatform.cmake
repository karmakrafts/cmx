if(NOT KSTD_PLATFORM_INCLUDED)
    include(CommonLibraries)

    set(KSTD_PLATFORM_VERSION master)
    set(KSTD_PLATFORM_FETCHED OFF)
    
    macro(target_include_kstd_platform target)
        if(NOT KSTD_PLATFORM_FETCHED)
            FetchContent_Declare(
                kstd-platform
                GIT_REPOSITORY https://github.com/karmakrafts/kstd-platform.git
                GIT_TAG ${KSTD_PLATFORM_VERSION}
            )
            FetchContent_MakeAvailable(kstd-platform)
            set(KSTD_PLATFORM_FETCHED ON)
        endif() # KSTD_PLATFORM_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/kstd-platform-src/include")
		target_link_libraries(${target} PUBLIC kstd-platform-static)
		add_dependencies(${target} kstd-platform-static)
    endmacro()

    set(KSTD_PLATFORM_INCLUDED ON)
endif() # KSTD_PLATFORM_INCLUDED
