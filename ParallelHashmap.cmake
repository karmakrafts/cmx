if (NOT CMX_PHMAP_INCLUDED)
	set(CMX_PHMAP_VERSION 1.3.11)
    set(CMX_PHMAP_FETCHED OFF)
    
    macro(target_include_phmap target)
    	set(num_args ${ARGC})
        if(num_args GREATER 0)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_PHMAP_FETCHED)
            FetchContent_Declare(
                phmap
                GIT_REPOSITORY https://github.com/greg7mdp/parallel-hashmap.git
                GIT_TAG "v${CMX_PHMAP_VERSION}"
            )
            FetchContent_MakeAvailable(phmap)
            set(CMX_PHMAP_FETCHED ON)
        endif() # CMX_PHMAP_FETCHED

        target_compile_definitions(${target} ${access} _SILENCE_CXX23_ALIGNED_STORAGE_DEPRECATION_WARNING)
        target_include_directories(${target} ${access} ${phmap_SOURCE_DIR})
    endmacro()
endif() # CMX_PHMAP_INCLUDED