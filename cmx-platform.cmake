include_guard()

if (CMAKE_CXX_COMPILER_ID MATCHES "Clang") # Do a match so we also match Apple Clang -.-
    set(CMX_COMPILER_CLANG TRUE)
    add_compile_definitions(COMPILER_CLANG)
    message(STATUS "Detected Clang compiler")
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMX_COMPILER_GCC TRUE)
    add_compile_definitions(COMPILER_GCC)
    message(STATUS "Detected GCC compiler")
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(CMX_COMPILER_MSVC TRUE)
    add_compile_definitions(COMPILER_MSVC)
    add_compile_options("/Zc:__cplusplus" "/utf-8") # Enable updated __cplusplus macro definition
    message(STATUS "Detected MSVC compiler")
endif () # CMAKE_CXX_COMPILER_ID

if (CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(CMX_CPU_64_BIT TRUE)
    add_compile_definitions(CPU_64_BIT)
else () # CMAKE_SIZEOF_VOID_P
    set(CMX_CPU_64_BIT FALSE)
    add_compile_definitions(CPU_32_BIT)
endif () # CMAKE_SIZEOF_VOID_P

if (CMAKE_SYSTEM_PROCESSOR MATCHES "[aA][rR][mM]64|[aA][aA]rch64")
    set(CMX_CPU_ARCH "arm64")
    set(CMX_CPU_ARM TRUE)
    set(CMX_CPU_ARM64 TRUE)
    add_compile_definitions(CPU_ARM64)
    add_compile_definitions(CPU_ARM)
    message(STATUS "Detected ARM64 based processor")
elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "[aA][rR][mM]")
    set(CMX_CPU_ARCH "arm")
    set(CMX_CPU_ARM TRUE)
    add_compile_definitions(CPU_ARM)
    message(STATUS "Detected ARM based processor")
elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "[pP][pP][cC]|[pP]ower[pP][cC]")
    set(CMX_CPU_ARCH "ppc")
    set(CMX_CPU_PPC TRUE)
    add_compile_definitions(CPU_PPC)
    message(STATUS "Detected PowerPC based processor")
elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "[xX]86[_\-]64|[xX]64|[aA][mM][dD]64")
    set(CMX_CPU_ARCH "x64")
    set(CMX_CPU_X86 TRUE)
    set(CMX_CPU_X86_64 TRUE)
    add_compile_definitions(CPU_X86)
    add_compile_definitions(CPU_X86_64)
    message(STATUS "Detected x86_64 based processor")
elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "[xX]86|i[3456]86")
    set(CMX_CPU_ARCH "x86")
    set(CMX_CPU_X86 TRUE)
    add_compile_definitions(CPU_X86)
    message(STATUS "Detected x86 based processor")
elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "[rR]isc[vV]64")
    set(CMX_CPU_ARCH "riscv64")
    set(CMX_CPU_RISCV TRUE)
    add_compile_definitions(CPU_RISCV)
    message(STATUS "Detected RISC-V based processor")
else ()
    message(FATAL_ERROR "Unsupported processor architecture: ${CMAKE_SYSTEM_PROCESSOR}")
endif () # CMAKE_SYSTEM_PROCESSOR

if (WIN32)
    set(CMX_PLATFORM "Windows")
    set(CMX_PLATFORM_WINDOWS TRUE)
    set(CMX_PLATFORM_SLIB_EXT "lib")
    set(CMX_PLATFORM_DLIB_EXT "dll")
    set(CMX_PLATFORM_LIB_PREFIX "")
    add_compile_definitions(PLATFORM_WINDOWS)
    link_libraries(
        kernel32.lib
        user32.lib
        Advapi32.lib
        Ws2_32.lib
        OneCore.lib
        dnsapi.lib
        gdi32.lib
        winspool.lib
        comdlg32.lib
        shell32.lib
        ole32.lib
        oleaut32.lib
        odbc32.lib
        odbccp32.lib
        ntdll.lib
        Wlanapi.lib) # Link common system libraries
    message(STATUS "Detected Windows operating system")
elseif (APPLE)
    set(CMX_PLATFORM "MacOS")
    set(CMX_PLATFORM_MACOS TRUE)
    set(CMX_PLATFORM_UNIX TRUE)
    set(CMX_PLATFORM_SLIB_EXT "a")
    set(CMX_PLATFORM_DLIB_EXT "dylib")
    set(CMX_PLATFORM_LIB_PREFIX "lib")
    add_compile_definitions(PLATFORM_APPLE)
    add_compile_definitions(PLATFORM_UNIX)
    message(STATUS "Detected Mac operating system")
elseif (UNIX)
    if (UNIX AND NOT APPLE)
        set(CMX_PLATFORM "Linux")
        set(CMX_PLATFORM_LINUX TRUE)
        add_compile_definitions(PLATFORM_LINUX)
        add_compile_definitions(PLATFORM_UNIX)
    else () # UNIX AND NOT APPLE
        set(CMX_PLATFORM "Unix")
        add_compile_definitions(PLATFORM_UNIX)
    endif () # UNIX AND NOT APPLE
    set(CMX_PLATFORM_UNIX TRUE)
    set(CMX_PLATFORM_SLIB_EXT "a")
    set(CMX_PLATFORM_DLIB_EXT "so")
    set(CMX_PLATFORM_LIB_PREFIX "lib")
    message(STATUS "Detected Unixoid operating system")
else ()
    message(FATAL_ERROR "Unsupported target platform '${CMAKE_SYSTEM_NAME}'")
endif ()

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CMX_BUILD_TYPE "debug")
    set(CMX_BUILD_DEBUG ON)
    add_compile_definitions(BUILD_DEBUG)
    if(CMX_PLATFORM_LINUX AND COMPILER_GCC)
        # Enable safe STL, disable inlining and optimizations
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0 -fno-inline -D_GLIBCXX_DEBUG_BACKTRACE")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0 -fno-inline -D_GLIBCXX_DEBUG_BACKTRACE")
    endif()
    if(CMX_PLATFORM_WINDOWS AND CMX_COMPILER_MSVC)
        add_compile_definitions(_ITERATOR_DEBUG_LEVEL=1) # Enable checked iterators
    endif()
else ()
    set(CMX_BUILD_RELEASE ON)
    set(CMX_BUILD_TYPE "release")
endif ()

string(TOLOWER ${CMX_PLATFORM} CMX_LC_PLATFORM)
set(CMX_PLATFORM_PAIR "${CMX_LC_PLATFORM}-${CMX_CPU_ARCH}")
message(STATUS "Determined platform pair '${CMX_PLATFORM_PAIR}'")

macro (cmx_use_mold)
    find_program(CMX_MOLD_EXECUTABLE "mold")
    if(CMX_MOLD_EXECUTABLE AND NOT CMX_COMPILER_CLANG) # mold doesn't work with Clang properly yet..
        message(STATUS "Detected mold linker, substituting")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fuse-ld=mold")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fuse-ld=mold")

        if(NOT DEFINED CMX_NUM_LINK_THREADS) # So we can pass this in via CLI
            cmake_host_system_information(RESULT CMX_NUM_LINK_THREADS QUERY NUMBER_OF_LOGICAL_CORES)
        endif() # NOT DEFINED NUM_LINK_THREADS

        message(STATUS "Using ${CMX_NUM_LINK_THREADS} threads for linking")
        add_link_options("LINKER:--threads,--thread-count=${CMX_NUM_LINK_THREADS}")
    endif() # MOLD_EXECUTABLE AND NOT COMPILER_CLANG
endmacro ()