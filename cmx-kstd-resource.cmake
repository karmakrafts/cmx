if(NOT CMX_KSTD_RESOURCE_INCLUDED)
    set(CMX_KSTD_RESOURCE_VERSION master)
    set(CMX_KSTD_RESOURCE_FETCHED OFF)
    
    macro(cmx_include_kstd_resource target)
        set(num_args ${ARGC})
        if(num_args GREATER 0)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_KSTD_RESOURCE_FETCHED)
            FetchContent_Declare(
                kstd-resource
                GIT_REPOSITORY https://github.com/karmakrafts/kstd-resource.git
                GIT_TAG ${CMX_KSTD_RESOURCE_VERSION}
            )
            FetchContent_MakeAvailable(kstd-resource)
            set(CMX_KSTD_RESOURCE_FETCHED ON)
        endif() # CMX_KSTD_RESOURCE_FETCHED

        target_include_directories(${target} ${access} "${kstd-resource_SOURCE_DIR}/include")
        target_link_libraries(${target} ${access} kstd-resource-static)
        add_dependencies(${target} kstd-resource-static)
    endmacro()

    set(CMX_KSTD_RESOURCE_INCLUDED ON)
endif() # CMX_KSTD_RESOURCE_INCLUDED