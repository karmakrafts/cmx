if(NOT CMX_EFI_INCLUDED)
    find_package(EFI)

    macro(cmx_include_efi target access)
        cmx_set_freestanding(${target} ${access})
        target_include_directories(${target} ${access} ${EFI_INCLUDE_DIR})
        target_link_libraries(${target} ${access} ${EFI_LIBRARIES})
        target_link_options(${target} ${access} -Wl,-L/usr/lib)
        target_compile_definitions(${target} ${access} EFI_FUNCTION_WRAPPER)
        if (DEFINED CMX_BUILD_DEBUG)
            target_compile_options(${target} ${access} -g -ggdb -O0)
        endif ()
    endmacro()

    macro(cmx_add_efi_executable target access)
        set(${target}_source_files)

        foreach (arg IN ITEMS ${ARGN})
            file(GLOB_RECURSE sources "${arg}/*.c*")
            list(APPEND ${target}_source_files ${sources})
            file(GLOB_RECURSE headers "${arg}/*.h*")
            list(APPEND ${target}_source_files ${headers})
        endforeach ()

        add_library(${target} SHARED ${{target}_source_files})
        cmx_include_efi(${target} ${access})
        target_link_options(${target} ${access} -T${EFI_LD_SCRIPT} ${EFI_CRT})

        if (DEFINED CMX_BUILD_DEBUG)
            add_custom_command(TARGET ${target} POST_BUILD
                    COMMAND objcopy
                    ARGS
                    -j .text
                    -j .sdata
                    -j .data
                    -j .dynamic
                    -j .dynsym
                    -j .rel
                    -j .rela
                    -j .reloc
                    -j .comment
                    -j .debug_line
                    -j .debug_line_str
                    -j .debug_info
                    -j .debug_abbrev
                    -j .debug_aranges
                    -j .debug_str
                    -j .debug_str_offsets
                    -j .debug_addr
                    -j .debug_frame
                    -j .debug_loc
                    -j .debug_macinfo
                    --target=efi-app-${CMAKE_HOST_SYSTEM_PROCESSOR}
                    $<TARGET_FILE:${target}> ${target}.efi
                    DEPENDS ${target}
                    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
        else ()
            add_custom_command(TARGET ${target} POST_BUILD
                    COMMAND objcopy
                    ARGS
                    -j .text
                    -j .sdata
                    -j .data
                    -j .dynamic
                    -j .dynsym
                    -j .rel
                    -j .rela
                    -j .reloc
                    --target=efi-app-${CMAKE_HOST_SYSTEM_PROCESSOR}
                    $<TARGET_FILE:${target}> ${target}.efi
                    DEPENDS ${target}
                    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
        endif ()

        unset(${target}_source_files)
        set(CMX_EFI_INCLUDED ON)
    endmacro()
endif()
