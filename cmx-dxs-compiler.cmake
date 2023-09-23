include_guard()

set(CMX_DXS_COMPILER_VERSION main)
set(CMX_DXS_COMPILER_FETCHED OFF)

macro(cmx_include_dxs_compiler target)
    set(num_args ${ARGC})
    if(num_args GREATER 1)
        set(access ${ARGV1}) # Copy first optional argument
    else()
        set(access PUBLIC) # Default to PUBLIC
    endif()
    if(NOT CMX_DXS_COMPILER_FETCHED)
        FetchContent_Declare(
            dxs-compiler
            GIT_REPOSITORY https://github.com/microsoft/DirectXShaderCompiler.git
            GIT_TAG ${CMX_DXS_COMPILER_VERSION}
        )
        FetchContent_MakeAvailable(dxs-compiler)
        set(CMX_DXS_COMPILER_FETCHED ON)
    endif() # CMX_DXS_COMPILER_FETCHED
    target_link_libraries(${target} ${access} dxcompiler)
    add_dependencies(${target} dxcompiler)
endmacro()