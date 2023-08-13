if(NOT CMX_KSTD_REFLECT_INCLUDED)
    set(CMX_KSTD_REFLECT_VERSION master)
    set(CMX_KSTD_REFLECT_FETCHED OFF)
    
    macro(cmx_include_kstd_reflect target)
        set(num_args ${ARGC})
        if(num_args GREATER 1)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_KSTD_REFLECT_FETCHED)
            FetchContent_Declare(
                kstd-reflect
                GIT_REPOSITORY https://github.com/karmakrafts/kstd-reflect.git
                GIT_TAG ${CMX_KSTD_REFLECT_VERSION}
            )
            FetchContent_MakeAvailable(kstd-reflect)
            set(CMX_KSTD_REFLECT_FETCHED ON)
        endif() # CMX_KSTD_REFLECT_FETCHED

        target_link_libraries(${target} ${access} kstd-reflect)
        add_dependencies(${target} kstd-reflect)
    endmacro()

    set(CMX_KSTD_REFLECT_INCLUDED ON)
endif() # CMX_KSTD_REFLECT_INCLUDED
