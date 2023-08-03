set(KSTD_STREAMS_VERSION master)
set(KSTD_STREAMS_FETCHED OFF)

macro(target_include_kstd_streams target)
	if(NOT KSTD_STREAMS_FETCHED)
    	FetchContent_Declare(
        	kstd-streams
        	GIT_REPOSITORY https://github.com/karmakrafts/kstd-streams.git
        	GIT_TAG "${KSTD_STREAMS_VERSION}"
    	)
		set(KSTD_STREAMS_FETCHED ON)
	endif()
    target_include_directories(${target} PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/_deps/kstd-streams-src/include")
endmacro()
