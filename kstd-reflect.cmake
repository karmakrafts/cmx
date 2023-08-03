set(KSTD_REFLECT_VERSION master)
set(KSTD_REFLECT_FETCHED OFF)

macro(target_include_kstd_reflect target)
	if(NOT KSTD_REFLECT_FETCHED)
    	FetchContent_Declare(
        	kstd-reflect
        	GIT_REPOSITORY https://github.com/karmakrafts/kstd-reflect.git
        	GIT_TAG "${KSTD_REFLECT_VERSION}"
    	)
		set(KSTD_REFLECT_FETCHED ON)
	endif()
    target_include_directories(${target} PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/_deps/kstd-reflect-src/include")
endmacro()
