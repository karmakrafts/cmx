if(NOT CMX_STDUUID_INCLUDED)
    set(CMX_STDUUID_VERSION master)
    set(CMX_STDUUID_FETCHED OFF)
    
    macro(cmx_include_stduuid target)
        set(num_args ${ARGC})
        if(num_args GREATER 1)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_STDUUID_FETCHED)
            FetchContent_Declare(
                stduuid
                GIT_REPOSITORY https://github.com/mariusbancila/stduuid.git
                GIT_TAG ${CMX_STDUUID_VERSION}
            )
            FetchContent_MakeAvailable(stduuid)
            set(CMX_STDUUID_FETCHED ON)
        endif() # CMX_STDUUID_FETCHED

        target_link_libraries(${target} ${access} stduuid)
        add_dependencies(${target} stduuid)
    endmacro()

    set(CMX_STDUUID_INCLUDED ON)
endif() # CMX_STDUUID_INCLUDED
