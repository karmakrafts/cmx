include_guard()

set(CMX_SDL2_IMAGE_VERSION CMX_SDL2)
set(CMX_SDL2_IMAGE_FETCHED OFF)

macro(cmx_include_sdl2_image target)
    set(num_args ${ARGC})
    if(num_args GREATER 1)
        set(access ${ARGV1}) # Copy first optional argument
    else()
        set(access PUBLIC) # Default to PUBLIC
    endif()
    if(NOT CMX_SDL2_IMAGE_FETCHED)
        FetchContent_Declare(
            sdl2-image
            GIT_REPOSITORY https://github.com/libsdl-org/SDL_image.git
            GIT_TAG ${CMX_SDL2_IMAGE_VERSION}
        )
        FetchContent_MakeAvailable(sdl2-image)
        set(CMX_SDL2_IMAGE_FETCHED ON)
    endif() # CMX_SDL2_IMAGE_FETCHED
    target_link_libraries(${target} ${access} SDL2_image)
    add_dependencies(${target} SDL2_image)
endmacro()