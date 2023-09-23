include_guard()

include(FetchContent)
set(CMX_VERSION master)

FetchContent_Declare(
    cmx
    GIT_REPOSITORY https://github.com/karmakrafts/cmx.git
    GIT_TAG ${CMX_VERSION}
)
FetchContent_MakeAvailable(cmx)

if (NOT "${cmx_SOURCE_DIR}" IN_LIST CMAKE_MODULE_PATH)
    list(APPEND CMAKE_MODULE_PATH "${cmx_SOURCE_DIR}")
endif ()
include(cmx)