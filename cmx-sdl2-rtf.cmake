if(NOT CMX_SDL2_RTF_INCLUDED)
    set(CMX_SDL2_RTF_VERSION CMX_SDL2)
    set(CMX_SDL2_RTF_FETCHED OFF)
    
    macro(cmx_include_sdl2_rtf target)
        set(num_args ${ARGC})
        if(num_args GREATER 0)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_SDL2_RTF_FETCHED)
            FetchContent_Declare(
                sdl2-rtf
                GIT_REPOSITORY https://github.com/libsdl-org/SDL_rtf.git
                GIT_TAG ${CMX_SDL2_RTF_VERSION}
            )
            FetchContent_MakeAvailable(sdl2-rtf)
            set(CMX_SDL2_RTF_FETCHED ON)
        endif() # CMX_SDL2_RTF_FETCHED

        target_include_directories(${target} ${access} "${sdl2-rtf_SOURCE_DIR}/include")
        target_link_libraries(${target} ${access} SDL2_rtf)
        add_dependencies(${target} SDL2_rtf)
    endmacro()

    set(CMX_SDL2_RTF_INCLUDED ON)
endif() # CMX_SDL2_RTF_INCLUDED