if(NOT KSTD_RESOURCE_INCLUDED)
    include(CommonLibraries)

    set(KSTD_RESOURCE_VERSION master)
    set(KSTD_RESOURCE_FETCHED OFF)
    
    macro(target_include_kstd_resource target)
        if(NOT KSTD_RESOURCE_FETCHED)
            FetchContent_Declare(
                kstd-resource
                GIT_REPOSITORY https://github.com/karmakrafts/kstd-resource.git
                GIT_TAG ${KSTD_RESOURCE_VERSION}
            )
            FetchContent_MakeAvailable(kstd-resource)
            set(KSTD_RESOURCE_FETCHED ON)
        endif() # KSTD_RESOURCE_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/kstd-resource-src/include")
        target_link_libraries(${target} PUBLIC kstd-resource::kstd-resource-static)
        add_dependencies(${target} kstd-resource::kstd-resource-static)
    endmacro()

    set(KSTD_RESOURCE_INCLUDED ON)
endif() # KSTD_RESOURCE_INCLUDED
