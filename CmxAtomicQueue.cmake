if(NOT CMX_ATOMIC_QUEUE_INCLUDED)
    set(CMX_ATOMIC_QUEUE_VERSION master)
    set(CMX_ATOMIC_QUEUE_FETCHED OFF)
    
    macro(cmx_include_atomic_queue target)
        set(num_args ${ARGC})
        if(num_args GREATER 0)
            set(access ${ARGV1}) # Copy first optional argument
        else()
            set(access PUBLIC) # Default to PUBLIC
        endif()

        if(NOT CMX_ATOMIC_QUEUE_FETCHED)
            FetchContent_Declare(
                atomic-queue
                GIT_REPOSITORY https://github.com/max0x7ba/atomic_queue.git
                GIT_TAG ${CMX_ATOMIC_QUEUE_VERSION}
            )
            FetchContent_MakeAvailable(atomic-queue)
            set(CMX_ATOMIC_QUEUE_FETCHED ON)
        endif() # CMX_ATOMIC_QUEUE_FETCHED

        target_include_directories(${target} ${access} "${atomic-queue_SOURCE_DIR}/include")
    endmacro()

    set(CMX_ATOMIC_QUEUE_INCLUDED ON)
endif() # CMX_ATOMIC_QUEUE_INCLUDED
