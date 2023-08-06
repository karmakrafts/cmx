if (NOT CMX_APPLICATION_INCLUDED)
	macro(cmx_add_application name source_dir include_dir)
		file(GLOB_RECURSE ${${name}_SOURCE_FILES} "${source_dir}/*.c*")
		add_executable(${name} ${${name}_SOURCE_FILES})
		target_include_directories(${name} PUBLIC ${include_dir})
		add_library("${name}-static" STATIC ${${name}_SOURCE_FILES})
		target_include_directories("${name}-static" PUBLIC ${include_dir})
	endmacro()

	set(CMX_APPLICATION_INCLUDED ON)
endif() # CMX_APPLICATION_INCLUDED
