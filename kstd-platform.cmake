set(KSTD_PLATFORM_VERSION master)
set(KSTD_PLATFORM_FETCHED OFF)

macro(target_include_kstd_platform target)
	if(NOT KSTD_PLATFORM_FETCHED)
    	FetchContent_Declare(
        	kstd-platform
        	GIT_REPOSITORY https://github.com/karmakrafts/kstd-platform.git
        	GIT_TAG "${KSTD_PLATFORM_VERSION}"
    	)
		set(KSTD_PLATFORM_FETCHED ON)
	endif()
	add_subdirectory("${CMAKE_CURRENT_BINARY_DIR}/_deps/kstd-platform-src")
    target_include_directories(${target} PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/_deps/kstd-platform-src/include")
endmacro()
