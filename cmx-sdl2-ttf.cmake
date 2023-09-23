include_guard()

set(CMX_SDL2_TTF_VERSION CMX_SDL2)
set(CMX_SDL2_TTF_FETCHED OFF)

macro(cmx_include_sdl2_ttf target)
    set(num_args ${ARGC})
    if(num_args GREATER 1)
        set(access ${ARGV1}) # Copy first optional argument
    else()
        set(access PUBLIC) # Default to PUBLIC
    endif()
    if(NOT CMX_SDL2_TTF_FETCHED)
        FetchContent_Declare(
            sdl2-ttf
            GIT_REPOSITORY https://github.com/libsdl-org/SDL_ttf.git
            GIT_TAG ${CMX_SDL2_TTF_VERSION}
        )
        FetchContent_MakeAvailable(sdl2-ttf)
        set(CMX_SDL2_TTF_FETCHED ON)
    endif() # CMX_SDL2_TTF_FETCHED
    target_link_libraries(${target} ${access} SDL2_ttf)
    add_dependencies(${target} SDL2_ttf)
endmacro()