include_guard()

if(NOT DEFINED CMAKE_CXX_STANDARD)
	message(STATUS "No C++ version specified, defaulting to C++20")
	set(CMAKE_CXX_STANDARD 20)
endif()

if(NOT DEFINED CMAKE_C_STANDARD)
	message(STATUS "No C version specified, defaulting to C17")
	set(CMAKE_C_STANDARD 17)
endif()