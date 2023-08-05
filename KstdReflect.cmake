if(NOT KSTD_REFLECT_INCLUDED)
    include(CommonLibraries)

    set(KSTD_REFLECT_VERSION master)
    set(KSTD_REFLECT_FETCHED OFF)
    
    macro(target_include_kstd_reflect target)
        if(NOT KSTD_REFLECT_FETCHED)
            FetchContent_Declare(
                kstd-reflect
                GIT_REPOSITORY https://github.com/karmakrafts/kstd-reflect.git
                GIT_TAG ${KSTD_REFLECT_VERSION}
            )
            FetchContent_MakeAvailable(kstd-reflect)
            set(KSTD_REFLECT_FETCHED ON)
        endif() # KSTD_REFLECT_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/kstd-reflect-src/include")
    endmacro()

    set(KSTD_REFLECT_INCLUDED ON)
endif() # KSTD_REFLECT_INCLUDED
