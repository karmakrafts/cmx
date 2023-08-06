if(NOT CMX_KSTD_CORE_INCLUDED)
    set(CMX_KSTD_CORE_VERSION master)
    set(CMX_KSTD_CORE_FETCHED OFF)
    
    macro(target_include_kstd_core target)
        set(num_args ${ARGC})
        if(num_args GREATER 0)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_KSTD_CORE_FETCHED)
            FetchContent_Declare(
                kstd-core
                GIT_REPOSITORY https://github.com/karmakrafts/kstd-core.git
                GIT_TAG ${CMX_KSTD_CORE_VERSION}
            )
            FetchContent_MakeAvailable(kstd-core)
            set(CMX_KSTD_CORE_FETCHED ON)
        endif() # CMX_KSTD_CORE_FETCHED

        target_include_directories(${target} ${access} "${kstd-core_SOURCE_DIR}/include")
    endmacro()

    set(CMX_KSTD_CORE_INCLUDED ON)
endif() # CMX_KSTD_CORE_INCLUDED
