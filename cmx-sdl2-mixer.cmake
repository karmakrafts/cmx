if(NOT CMX_SDL2_MIXER_INCLUDED)
    set(CMX_SDL2_MIXER_VERSION CMX_SDL2)
    set(CMX_SDL2_MIXER_FETCHED OFF)
    
    macro(cmx_include_sdl2_mixer target)
        set(num_args ${ARGC})
        if(num_args GREATER 1)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_SDL2_MIXER_FETCHED)
            FetchContent_Declare(
                sdl2-mixer
                GIT_REPOSITORY https://github.com/libsdl-org/SDL_mixer.git
                GIT_TAG ${CMX_SDL2_MIXER_VERSION}
            )
            FetchContent_MakeAvailable(sdl2-mixer)
            set(CMX_SDL2_MIXER_FETCHED ON)
        endif() # CMX_SDL2_MIXER_FETCHED

        target_link_libraries(${target} ${access} SDL2_mixer)
        add_dependencies(${target} SDL2_mixer)
    endmacro()

    set(CMX_SDL2_MIXER_INCLUDED ON)
endif() # CMX_SDL2_MIXER_INCLUDED
