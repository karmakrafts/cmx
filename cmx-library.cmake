if (NOT CMX_LIBRARY_INCLUDED)
	macro(cmx_add_library type name)
		set(${name}_source_files)

		foreach (arg IN ITEMS ${ARGN})
			file(GLOB_RECURSE sources "${arg}/*.c*")
			list(APPEND ${name}_source_files ${sources})
			file(GLOB_RECURSE headers "${arg}/*.h*")
			list(APPEND ${name}_source_files ${headers})
		endforeach()

		string(TOLOWER "${type}" full_name)
		math(EXPR num_extra_args "${ARGC} - 2" DECIMAL)

		if (${num_extra_args} GREATER 0)
			add_library(${full_name} ${type} ${${name}_source_files})
		else()
			add_library(${full_name} ${type})
		endif()

		unset(full_name)
		unset(num_extra_args)
		unset(${name}_source_files)
	endmacro()

	set(CMX_LIBRARY_INCLUDED ON)
endif() # CMX_LIBRARY_INCLUDED
