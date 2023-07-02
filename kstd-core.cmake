set(KSTD_CORE_VERSION master)

macro(target_include_kstd_core target)
    FetchContent_Declare(
        kstd-core
        GIT_REPOSITORY https://github.com/karmakrafts/kstd-core.git
        GIT_TAG "${KSTD_CORE_VERSION}"
    )
    FetchContent_MakeAvailable(kstd-core)
    target_include_directories(${target} PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/_deps/kstd-core-src/include")
endmacro()