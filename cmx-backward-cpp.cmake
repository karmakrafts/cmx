include_guard()

set(CMX_BACKWARD_CPP_VERSION v1.6)
set(CMX_BACKWARD_CPP_FETCHED OFF)
    
macro(cmx_include_backward_cpp target)
    set(num_args ${ARGC})
    if(num_args GREATER 1)
        set(access ${ARGV1}) # Copy first optional argument
    else()
        set(access PUBLIC) # Default to PUBLIC
    endif()
    if(NOT CMX_BACKWARD_CPP_FETCHED)
        FetchContent_Declare(
            backward-cpp
            GIT_REPOSITORY https://github.com/bombela/backward-cpp.git
            GIT_TAG ${CMX_BACKWARD_CPP_VERSION}
        )
        FetchContent_MakeAvailable(backward-cpp)
        set(CMX_BACKWARD_CPP_FETCHED ON)
    endif() # CMX_BACKWARD_CPP_FETCHED
    target_link_libraries(${target} ${access} backward)
    add_dependencies(${target} backward)
endmacro()