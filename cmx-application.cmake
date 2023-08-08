if (NOT CMX_APPLICATION_INCLUDED)
	macro(cmx_add_application name)
		set(${name}_SOURCE_FILES)

		foreach (arg IN ITEMS ${ARGN})
			file(GLOB_RECURSE sources "${arg}/*.c*")
			list(APPEND ${name}_SOURCE_FILES ${sources})
			file(GLOB_RECURSE headers "${arg}/*.h*")
			list(APPEND ${name}_SOURCE_FILES ${headers})
		endforeach()

		add_executable(${name} ${${name}_SOURCE_FILES})
		add_library("${name}-static" STATIC ${${name}_SOURCE_FILES})
	endmacro()

	set(CMX_APPLICATION_INCLUDED ON)
endif() # CMX_APPLICATION_INCLUDED
