set(CL_KSTD_REFLECT_VERSION master)

macro(target_include_kstd_reflect target)
    FetchContent_Declare(
        kstd-reflect
        GIT_REPOSITORY https://github.com/karmakrafts/kstd-reflect.git
        GIT_TAG ${CL_KSTD_REFLECT_VERSION}
    )
    FetchContent_MakeAvailable(kstd-reflect)
    target_include_directories(${target} PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/_deps/kstd-reflect-src/include")
endmacro()
