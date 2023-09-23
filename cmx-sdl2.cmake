include_guard()

set(CMX_SDL2_VERSION CMX_SDL2)
set(CMX_SDL2_FETCHED OFF)

macro(cmx_include_sdl2 target)
    set(num_args ${ARGC})
    if(num_args GREATER 1)
        set(access ${ARGV1}) # Copy first optional argument
    else()
        set(access PUBLIC) # Default to PUBLIC
    endif()
    if(NOT CMX_SDL2_FETCHED)
        FetchContent_Declare(
            sdl2
            GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
            GIT_TAG ${CMX_SDL2_VERSION}
        )
        FetchContent_MakeAvailable(sdl2)
        set(CMX_SDL2_FETCHED ON)
    endif() # CMX_SDL2_FETCHED
    target_link_libraries(${target} ${access} SDL2-static)
    add_dependencies(${target} SDL2-static)
endmacro()