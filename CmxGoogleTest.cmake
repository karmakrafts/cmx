if (NOT CMX_GTEST_INCLUDED)
	set(CMX_GTEST_VERSION 1.13.0)
    set(CMX_GTEST_FETCHED OFF)

    macro(cmx_include_gtest target)
    	set(num_args ${ARGC})
        if(num_args GREATER 0)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        set(gtest_force_shared_crt OFF CACHE BOOL "" FORCE)

        if(NOT CMX_GTEST_FETCHED)
            FetchContent_Declare(
                google-test
                GIT_REPOSITORY https://github.com/google/googletest.git
                GIT_TAG "v${CMX_GTEST_VERSION}")
            FetchContent_MakeAvailable(google-test)
            set(CMX_GTEST_FETCHED ON)
        endif() # CMX_GTEST_FETCHED

        enable_testing(TRUE)
        include(GoogleTest)
        gtest_discover_tests(${target})
        target_link_libraries(${target} ${access} gtest_main)
    endmacro()
endif() # CMX_GTEST_INCLUDED
