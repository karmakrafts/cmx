if(NOT SDL2_IMAGE_INCLUDED)
    include(CommonLibraries)

    set(SDL2_IMAGE_VERSION SDL2)
    set(SDL2_IMAGE_FETCHED OFF)
    
    macro(target_include_sdl2_image target)
        if(NOT SDL2_IMAGE_FETCHED)
            FetchContent_Declare(
                sdl2-image
                GIT_REPOSITORY https://github.com/libsdl-org/SDL_image.git
                GIT_TAG ${SDL2_IMAGE_VERSION}
            )
            FetchContent_MakeAvailable(sdl2-image)
            set(SDL2_IMAGE_FETCHED ON)
        endif() # SDL2_IMAGE_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/sdl2-image-src/include")
        target_link_libraries(${target} PUBLIC SDL2_image::SDL2_image)
        add_dependencies(${target} SDL2_image::SDL2_image)
    endmacro()

    set(SDL2_IMAGE_INCLUDED ON)
endif() # SDL2_IMAGE_INCLUDED
