if(NOT CMX_SPIRV_REFLECT_INCLUDED)
    set(CMX_SPIRV_REFLECT_VERSION main)
    set(CMX_SPIRV_REFLECT_FETCHED OFF)
    
    macro(cmx_include_spirv_reflect target)
        set(num_args ${ARGC})
        if(num_args GREATER 1)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_SPIRV_REFLECT_FETCHED)
            FetchContent_Declare(
                spirv-reflect
                GIT_REPOSITORY https://github.com/KhronosGroup/SPIRV-Reflect.git
                GIT_TAG ${CMX_SPIRV_REFLECT_VERSION}
            )
            FetchContent_MakeAvailable(spirv-reflect)
            add_subdirectory(${spirv-reflect_SOURCE_DIR})
            set(CMX_SPIRV_REFLECT_FETCHED ON)
        endif() # CMX_SPIRV_REFLECT_FETCHED

        target_link_libraries(${target} ${access} spirv-reflect-static)
        add_dependencies(${target} spirv-reflect-static)
    endmacro()

    set(CMX_SPIRV_REFLECT_INCLUDED ON)
endif() # CMX_SPIRV_REFLECT_INCLUDED
