if(NOT SDL2_RTF_INCLUDED)
    include(CommonLibraries)

    set(SDL2_RTF_VERSION SDL2)
    set(SDL2_RTF_FETCHED OFF)
    
    macro(target_include_sdl2_rtf target)
        if(NOT SDL2_RTF_FETCHED)
            FetchContent_Declare(
                sdl2-rtf
                GIT_REPOSITORY https://github.com/libsdl-org/SDL_rtf.git
                GIT_TAG ${SDL2_RTF_VERSION}
            )
            FetchContent_MakeAvailable(sdl2-rtf)
            set(SDL2_RTF_FETCHED ON)
        endif() # SDL2_RTF_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/sdl2-rtf-src/include")
        target_link_libraries(${target} PUBLIC SDL2_rtf::SDL2_rtf)
        add_dependencies(${target} SDL2_rtf::SDL2_rtf)
    endmacro()

    set(SDL2_RTF_INCLUDED ON)
endif() # SDL2_RTF_INCLUDED
