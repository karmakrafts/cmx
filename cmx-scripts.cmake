if (NOT CMX_CMAKE_SCRIPTS_INCLUDED)
	include(cmx-platform)
	set(CMX_CMAKE_SCRIPTS_VERSION 23.06)
    set(CMX_CMAKE_SCRIPTS_FETCHED OFF)

    macro(cmx_include_scripts)
        if(NOT CMX_CMAKE_SCRIPTS_FETCHED)
            FetchContent_Declare(
                cmake-scripts
                GIT_REPOSITORY https://github.com/StableCoder/cmake-scripts.git
                GIT_TAG ${CMX_CMAKE_SCRIPTS_VERSION})
            FetchContent_Populate(cmake-scripts)
            set(CMX_CMAKE_SCRIPTS_FETCHED ON)
        endif() # CMX_CMAKE_SCRIPTS_FETCHED

        set(CMAKE_MODULE_PATH "${cmake-scripts_SOURCE_DIR};")
        set(ENABLE_ALL_WARNINGS ON)

        include(compiler-options)

        if (NOT CMX_COMPILER_MSVC AND NOT ((CMX_PLATFORM_WINDOWS OR CMX_CPU_RISCV) AND CMX_COMPILER_CLANG))
            if(CMX_BUILD_DEBUG)
                set(USE_SANITIZER Thread,Undefined)
            else() # CMX_BUILD_DEBUG
                set(USE_SANITIZER "")
            endif() # CMX_BUILD_DEBUG
            include(sanitizers)
        endif () # CMX_COMPILER_MSVC
    endmacro()
endif() # CMX_CMAKE_SCRIPTS_INCLUDED
