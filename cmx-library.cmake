if (NOT CMX_LIBRARY_INCLUDED)
	macro(cmx_add_library name header_dir)
		set(${name}_SOURCE_FILES)

		foreach (arg IN ITEMS ${ARGN})
			file(GLOB_RECURSE sources "${arg}/*.c*")
			list(APPEND ${name}_SOURCE_FILES ${sources})
			file(GLOB_RECURSE headers "${arg}/*.h*")
			list(APPEND ${name}_SOURCE_FILES ${headers})
		endforeach()

		add_library(${name} SHARED ${${name}_SOURCE_FILES})
		target_include_directories(${name} PRIVATE ${header_dir})

		add_library("${name}-static" STATIC ${${name}_SOURCE_FILES})
		target_include_directories("${name}-static" PRIVATE ${header_dir})
	endmacro()

	set(CMX_LIBRARY_INCLUDED ON)
endif() # CMX_LIBRARY_INCLUDED
