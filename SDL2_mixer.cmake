if(NOT SDL2_MIXER_INCLUDED)
    include(CommonLibraries)

    set(SDL2_MIXER_VERSION SDL2)
    set(SDL2_MIXER_FETCHED OFF)
    
    macro(target_include_sdl2_mixer target)
        if(NOT SDL2_MIXER_FETCHED)
            FetchContent_Declare(
                sdl2-mixer
                GIT_REPOSITORY https://github.com/libsdl-org/SDL_mixer.git
                GIT_TAG ${SDL2_MIXER_VERSION}
            )
            FetchContent_MakeAvailable(sdl2-mixer)
            set(SDL2_MIXER_FETCHED ON)
        endif() # SDL2_MIXER_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/sdl2-mixer-src/include")
        target_link_libraries(${target} PUBLIC SDL2_mixer::SDL2_mixer)
        add_dependencies(${target} SDL2_mixer::SDL2_mixer)
    endmacro()

    set(SDL2_MIXER_INCLUDED ON)
endif() # SDL2_MIXER_INCLUDED
