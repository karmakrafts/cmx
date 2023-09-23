include_guard()

set(CMX_LIBJPEG_TURBO_VERSION main)
set(CMX_LIBJPEG_TURBO_FETCHED OFF)

macro(cmx_include_libjpeg_turbo target)
    set(num_args ${ARGC})
    if(num_args GREATER 1)
        set(access ${ARGV1}) # Copy first optional argument
    else()
        set(access PUBLIC) # Default to PUBLIC
    endif()
    if(NOT CMX_LIBJPEG_TURBO_FETCHED)
        FetchContent_Declare(
            libjpeg-turbo
            GIT_REPOSITORY https://github.com/libjpeg-turbo/libjpeg-turbo.git
            GIT_TAG ${CMX_LIBJPEG_TURBO_VERSION}
        )
        FetchContent_MakeAvailable(libjpeg-turbo)
        set(CMX_LIBJPEG_TURBO_FETCHED ON)
    endif() # CMX_LIBJPEG_TURBO_FETCHED
    target_link_libraries(${target} ${access} jpeg-static)
    add_dependencies(${target} jpeg-static)
endmacro()