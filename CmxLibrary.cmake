if (NOT CMX_LIBRARY_INCLUDED)
	macro(cmx_add_library name source_dir)
		file(GLOB_RECURSE ${name}_SOURCE_FILES "${source_dir}/*.c*")
		file(GLOB_RECURSE ${name}_HEADER_FILES "${source_dir}/*.h*")
		add_library(${name} SHARED ${${name}_SOURCE_FILES} ${${name}_HEADER_FILES})
		add_library("${name}-static" STATIC ${${name}_SOURCE_FILES} ${${name}_HEADER_FILES})
	endmacro()

	set(CMX_LIBRARY_INCLUDED ON)
endif() # CMX_LIBRARY_INCLUDED
