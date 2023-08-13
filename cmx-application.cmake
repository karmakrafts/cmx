if (NOT CMX_APPLICATION_INCLUDED)
	macro(cmx_add_application name)
		set(${name}_source_files)

		foreach (arg IN ITEMS ${ARGN})
			file(GLOB_RECURSE sources "${arg}/*.c*")
			list(APPEND ${name}_source_files ${sources})
			file(GLOB_RECURSE headers "${arg}/*.h*")
			list(APPEND ${name}_source_files ${headers})
		endforeach()

		add_executable(${name} ${${name}_source_files})
		add_library("${name}-static" STATIC ${${name}_source_files})

		unset(${name}_source_files)
	endmacro()

	set(CMX_APPLICATION_INCLUDED ON)
endif() # CMX_APPLICATION_INCLUDED
