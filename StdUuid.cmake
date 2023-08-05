if(NOT STDUUID_INCLUDED)
    include(CommonLibraries)

    set(STDUUID_VERSION master)
    set(STDUUID_FETCHED OFF)
    
    macro(target_include_stduuid target)
        if(NOT STDUUID_FETCHED)
            FetchContent_Declare(
                stduuid
                GIT_REPOSITORY https://github.com/mariusbancila/stduuid.git
                GIT_TAG ${STDUUID_VERSION}
            )
            FetchContent_MakeAvailable(stduuid)
            set(STDUUID_FETCHED ON)
        endif() # STDUUID_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/stduuid-src/include")
    endmacro()

    set(STDUUID_INCLUDED ON)
endif() # STDUUID_INCLUDED
