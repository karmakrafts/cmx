include_guard()

set(CMX_GLM_VERSION master)
set(CMX_GLM_FETCHED OFF)

macro(cmx_include_glm target)
    set(num_args ${ARGC})
    if(num_args GREATER 1)
        set(access ${ARGV1}) # Copy first optional argument
    else()
        set(access PUBLIC) # Default to PUBLIC
    endif()
    if(NOT CMX_GLM_FETCHED)
        FetchContent_Declare(
            glm
            GIT_REPOSITORY https://github.com/g-truc/glm.git
            GIT_TAG ${CMX_GLM_VERSION}
        )
        FetchContent_MakeAvailable(glm)
        set(CMX_GLM_FETCHED ON)
    endif() # CMX_GLM_FETCHED
    target_link_libraries(${target} ${access} glm)
    add_dependencies(${target} glm)
endmacro()