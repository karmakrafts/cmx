if(NOT SDL2_NET_INCLUDED)
    include(CommonLibraries)

    set(SDL2_NET_VERSION SDL2)
    set(SDL2_NET_FETCHED OFF)
    
    macro(target_include_sdl2_net target)
        if(NOT SDL2_NET_FETCHED)
            FetchContent_Declare(
                sdl2-net
                GIT_REPOSITORY https://github.com/libsdl-org/SDL_net.git
                GIT_TAG ${SDL2_NET_VERSION}
            )
            FetchContent_MakeAvailable(sdl2-net)
            set(SDL2_NET_FETCHED ON)
        endif() # SDL2_NET_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/sdl2-net-src/include")
        target_link_libraries(${target} PUBLIC SDL2_net::SDL2_net)
        add_dependencies(${target} SDL2_net::SDL2_net)
    endmacro()

    set(SDL2_NET_INCLUDED ON)
endif() # SDL2_NET_INCLUDED
