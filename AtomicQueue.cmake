if(NOT ATOMIC_QUEUE_INCLUDED)
    include(CommonLibraries)

    set(ATOMIC_QUEUE_VERSION master)
    set(ATOMIC_QUEUE_FETCHED OFF)
    
    macro(target_include_atomic_queue target)
        if(NOT ATOMIC_QUEUE_FETCHED)
            FetchContent_Declare(
                atomic-queue
                GIT_REPOSITORY https://github.com/max0x7ba/atomic_queue.git
                GIT_TAG ${ATOMIC_QUEUE_VERSION}
            )
            FetchContent_MakeAvailable(atomic-queue)
            set(ATOMIC_QUEUE_FETCHED ON)
        endif() # ATOMIC_QUEUE_FETCHED

        target_include_directories(${target} PUBLIC "${CL_DEPS_DIR}/atomic-queue-src/include")
    endmacro()

    set(ATOMIC_QUEUE_INCLUDED ON)
endif() # ATOMIC_QUEUE_INCLUDED
