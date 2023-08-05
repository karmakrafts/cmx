if(NOT KSTD_CORE_INCLUDED)
    include(CommonLibraries)

    set(KSTD_CORE_VERSION master)
    set(KSTD_CORE_FETCHED OFF)
    
    macro(target_include_kstd_core target)
        if(NOT KSTD_CORE_FETCHED)
            FetchContent_Declare(
                kstd-core
                GIT_REPOSITORY https://github.com/karmakrafts/kstd-core.git
                GIT_TAG ${KSTD_CORE_VERSION}
            )
            FetchContent_MakeAvailable(kstd-core)
            set(KSTD_CORE_FETCHED ON)
        endif() # KSTD_CORE_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/kstd-core-src/include")
    endmacro()

    set(KSTD_CORE_INCLUDED ON)
endif() # KSTD_CORE_INCLUDED
