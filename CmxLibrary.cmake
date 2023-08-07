if (NOT CMX_LIBRARY_INCLUDED)
	macro(cmx_add_library name source_dir include_dir)
		file(GLOB_RECURSE ${name}_SOURCE_FILES "${source_dir}/*.c*")
		add_library(${name} SHARED ${${name}_SOURCE_FILES})
		target_include_directories(${name} PUBLIC ${include_dir})
		add_library("${name}-static" STATIC ${${name}_SOURCE_FILES})
		target_include_directories("${name}-static" PUBLIC ${include_dir})
	endmacro()

	set(CMX_LIBRARY_INCLUDED ON)
endif() # CMX_LIBRARY_INCLUDED
