include_guard()

set(CMX_EFITEST_VERSION master)
set(CMX_EFITEST_FETCHED OFF)
    
macro(cmx_include_efitest target)
    set(num_args ${ARGC})
    if(num_args GREATER 1)
        set(access ${ARGV1}) # Copy first optional argument
    else()
        set(access PUBLIC) # Default to PUBLIC
    endif()
    if(NOT CMX_EFITEST_FETCHED)
        FetchContent_Declare(
            efitest
            GIT_REPOSITORY https://github.com/kos-project/libefitest.git
            GIT_TAG ${CMX_EFITEST_VERSION}
        )
        FetchContent_MakeAvailable(efitest)
        set(CMX_EFITEST_FETCHED ON)
    endif() # CMX_EFITEST_FETCHED
endmacro()