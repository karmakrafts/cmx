if(NOT KSTD_IO_INCLUDED)
    include(CommonLibraries)

    set(KSTD_IO_VERSION master)
    set(KSTD_IO_FETCHED OFF)
    
    macro(target_include_kstd_io target)
        if(NOT KSTD_IO_FETCHED)
            FetchContent_Declare(
                kstd-io
                GIT_REPOSITORY https://github.com/karmakrafts/kstd-io.git
                GIT_TAG ${KSTD_IO_VERSION}
            )
            FetchContent_MakeAvailable(kstd-io)
            set(KSTD_IO_FETCHED ON)
        endif() # KSTD_IO_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/kstd-io-src/include")
		target_link_libraries(${target} PUBLIC kstd-io-static)
		add_dependencies(${target} kstd-io-static)
    endmacro()

    set(KSTD_IO_INCLUDED ON)
endif() # KSTD_IO_INCLUDED
