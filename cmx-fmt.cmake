if (NOT CMX_FMT_INCLUDED)
    set(CMX_FMT_VERSION 10.0.0)
    set(CMX_FMT_FETCHED OFF)
    
    macro(cmx_include_fmt target)
    	set(num_args ${ARGC})
        if(num_args GREATER 1)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_FMT_FETCHED)
            FetchContent_Declare(
                fmt
                GIT_REPOSITORY https://github.com/fmtlib/fmt.git
                GIT_TAG ${CMX_FMT_VERSION}
            )
            FetchContent_MakeAvailable(fmt)
            set(CMX_FMT_FETCHED ON)
        endif() # CMX_FMT_FETCHED

        target_compile_definitions(${target} ${access}
            FMT_HEADER_ONLY=1
            FMT_EXCEPTIONS=0
            FMT_NOEXCEPT=1)
        target_include_directories(${target} ${access} "${fmt_SOURCE_DIR}/include")
    endmacro()
endif() # CMX_FMT_INCLUDED