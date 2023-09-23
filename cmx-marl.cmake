include_guard()

set(CMX_MARL_VERSION main)
set(CMX_MARL_FETCHED OFF)

macro(cmx_include_marl target)
    set(num_args ${ARGC})
    if(num_args GREATER 1)
        set(access ${ARGV1}) # Copy first optional argument
    else()
        set(access PUBLIC) # Default to PUBLIC
    endif()
    if(NOT CMX_MARL_FETCHED)
        FetchContent_Declare(
            marl
            GIT_REPOSITORY https://github.com/google/marl.git
            GIT_TAG ${CMX_MARL_VERSION}
        )
        FetchContent_MakeAvailable(marl)
        set(CMX_MARL_FETCHED ON)
    endif() # CMX_MARL_FETCHED
    target_link_libraries(${target} ${access} marl)
    add_dependencies(${target} marl)
endmacro()