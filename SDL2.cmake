if(NOT SDL2_INCLUDED)
    include(CommonLibraries)

    set(SDL2_VERSION SDL2)
    set(SDL2_FETCHED OFF)
    
    macro(target_include_sdl2 target)
        if(NOT SDL2_FETCHED)
            FetchContent_Declare(
                sdl2
                GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
                GIT_TAG ${SDL2_VERSION}
            )
            FetchContent_MakeAvailable(sdl2)
            set(SDL2_FETCHED ON)
        endif() # SDL2_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/sdl2-src/include")
        target_link_libraries(${target} PUBLIC SDL2::SDL2)
        add_dependencies(${target} SDL2::SDL2)
    endmacro()

    set(SDL2_INCLUDED ON)
endif() # SDL2_INCLUDED
