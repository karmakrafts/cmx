include_guard()

macro(cmx_set_freestanding target access)
	if(DEFINED CMX_COMPILER_MSVC)
		message(FATAL_ERROR "Freestanding compilation with MSVC is not supported right now")
	endif()
	target_compile_options(${target} ${access}
		-fPIC
		-fshort-wchar
		-ffreestanding
		-fno-stack-protector
		-mno-red-zone)
	target_link_options(${target} ${access}
		-nostdlib
		-Wl,-Bsymbolic)
	if(CMX_COMPILER_GCC)
		target_link_options(${target} ${access} -znocombreloc)
	endif()
endmacro()
