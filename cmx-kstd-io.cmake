if(NOT CMX_KSTD_IO_INCLUDED)
    set(CMX_KSTD_IO_VERSION master)
    set(CMX_KSTD_IO_FETCHED OFF)
    
    macro(cmx_include_kstd_io target)
        set(num_args ${ARGC})
        if(num_args GREATER 1)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_KSTD_IO_FETCHED)
            FetchContent_Declare(
                kstd-io
                GIT_REPOSITORY https://github.com/karmakrafts/kstd-io.git
                GIT_TAG ${CMX_KSTD_IO_VERSION}
            )
            FetchContent_MakeAvailable(kstd-io)
            set(CMX_KSTD_IO_FETCHED ON)
        endif() # CMX_KSTD_IO_FETCHED

        target_link_libraries(${target} ${access} kstd-io)
        add_dependencies(${target} kstd-io)
    endmacro()

    set(CMX_KSTD_IO_INCLUDED ON)
endif() # CMX_KSTD_IO_INCLUDED
