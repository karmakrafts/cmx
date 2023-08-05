if(NOT SDL2_TTF_INCLUDED)
    include(CommonLibraries)

    set(SDL2_TTF_VERSION SDL2)
    set(SDL2_TTF_FETCHED OFF)
    
    macro(target_include_sdl2_ttf target)
        if(NOT SDL2_TTF_FETCHED)
            FetchContent_Declare(
                sdl2-ttf
                GIT_REPOSITORY https://github.com/libsdl-org/SDL_ttf.git
                GIT_TAG ${SDL2_TTF_VERSION}
            )
            FetchContent_MakeAvailable(sdl2-ttf)
            set(SDL2_TTF_FETCHED ON)
        endif() # SDL2_TTF_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/sdl2-ttf-src/include")
        target_link_libraries(${target} PUBLIC SDL2_ttf::SDL2_ttf)
        add_dependencies(${target} SDL2_ttf::SDL2_ttf)
    endmacro()

    set(SDL2_TTF_INCLUDED ON)
endif() # SDL2_TTF_INCLUDED
