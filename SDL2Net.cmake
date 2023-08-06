if(NOT CMX_SDL2_NET_INCLUDED)
    set(CMX_SDL2_NET_VERSION CMX_SDL2)
    set(CMX_SDL2_NET_FETCHED OFF)
    
    macro(target_include_sdl2_net target)
        set(num_args ${ARGC})
        if(num_args GREATER 0)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_SDL2_NET_FETCHED)
            FetchContent_Declare(
                sdl2-net
                GIT_REPOSITORY https://github.com/libsdl-org/SDL_net.git
                GIT_TAG ${CMX_SDL2_NET_VERSION}
            )
            FetchContent_MakeAvailable(sdl2-net)
            set(CMX_SDL2_NET_FETCHED ON)
        endif() # CMX_SDL2_NET_FETCHED

        target_include_directories(${target} ${access} "${sdl2-net_SOURCE_DIR}/include")
        target_link_libraries(${target} ${access} SDL2_net)
        add_dependencies(${target} SDL2_net)
    endmacro()

    set(CMX_SDL2_NET_INCLUDED ON)
endif() # CMX_SDL2_NET_INCLUDED
