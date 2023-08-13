if(NOT CMX_KSTD_CORE_INCLUDED)
    set(CMX_KSTD_CORE_VERSION master)
    set(CMX_KSTD_CORE_FETCHED OFF)
    
    macro(cmx_include_kstd_core target)
        set(num_args ${ARGC})
        if(num_args GREATER 1)
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
            add_subdirectory(${kstd-core_SOURCE_DIR})
            set(CMX_KSTD_CORE_FETCHED ON)
        endif() # CMX_KSTD_CORE_FETCHED

        target_link_libraries(${target} ${access} kstd-core)
        add_dependencies(${target} kstd-core)
    endmacro()

    set(CMX_KSTD_CORE_INCLUDED ON)
endif() # CMX_KSTD_CORE_INCLUDED
