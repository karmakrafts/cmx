include_guard()

macro(cmx_set_freestanding target access)
	if(DEFINED CMX_COMPILER_MSVC)
		message(FATAL_ERROR "Freestanding compilation with MSVC is not supported right now")
	endif()
	target_compile_options(${target} ${access}
		-fshort-wchar
		-ffreestanding
		-fPIC
		-fno-stack-protector
		-fno-strict-aliasing
		-funsigned-char)
	target_link_options(${target} ${access}
		-nostdlib
		-Wl,-Bsymbolic)
	if(DEFINED CMX_COMPILER_GCC)
		target_link_options(${target} ${access}
			-znocombreloc)
	endif()
endmacro()
