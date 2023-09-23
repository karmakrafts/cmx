include_guard()

set(CMX_LIBPNG_VERSION master)
set(CMX_LIBPNG_FETCHED OFF)

macro(cmx_include_libpng target)
    set(num_args ${ARGC})
    if(num_args GREATER 1)
        set(access ${ARGV1}) # Copy first optional argument
    else()
        set(access PUBLIC) # Default to PUBLIC
    endif()
    if(NOT CMX_LIBPNG_FETCHED)
        FetchContent_Declare(
            libpng
            GIT_REPOSITORY https://github.com/glennrp/libpng.git
            GIT_TAG ${CMX_LIBPNG_VERSION}
        )
        FetchContent_MakeAvailable(libpng)
        set(CMX_LIBPNG_FETCHED ON)
    endif() # CMX_LIBPNG_FETCHED
    target_link_libraries(${target} ${access} png_static)
    add_dependencies(${target} png_static)
endmacro()