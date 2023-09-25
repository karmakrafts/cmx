include_guard()

set(CMX_EFITEST_VERSION master)
set(CMX_EFITEST_FETCHED OFF)

if(NOT CMX_EFITEST_FETCHED)
    FetchContent_Declare(
        efitest
        GIT_REPOSITORY https://github.com/kos-project/libefitest.git
        GIT_TAG ${CMX_EFITEST_VERSION}
    )
    FetchContent_MakeAvailable(efitest)
    set(EFITEST_SOURCE_DIR "${efitest_SOURCE_DIR}")
    set(CMX_EFITEST_FETCHED ON)
endif() # CMX_EFITEST_FETCHED