if (NOT CMX_EFI_INCLUDED)
    find_package(EFI)

    macro(cmx_include_efi target access)
        cmx_set_freestanding(${target} ${access})
        target_include_directories(${target} ${access} ${EFI_INCLUDE_DIR})
        target_link_libraries(${target} ${access} ${EFI_LIBRARIES})
        target_link_options(${target} ${access} -Wl,-L/usr/lib)
        target_compile_definitions(${target} ${access} EFI_FUNCTION_WRAPPER)
        if (DEFINED CMX_BUILD_DEBUG)
            target_compile_options(${target} ${access} -g1 -ggdb)
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

        add_library(${target} SHARED ${${target}_source_files})
        cmx_include_efi(${target} ${access})
        target_link_options(${target} ${access} -T${EFI_LD_SCRIPT} ${EFI_CRT})

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
    endmacro()

    macro(cmx_add_esp_image target)
        find_program(DD "dd")
        find_program(MKFS "mkfs.fat")
        find_program(MMD "mmd")
        find_program(MCOPY "mcopy")

        if (NOT DD OR NOT MKFS OR NOT MMD OR NOT MCOPY)
            message(FATAL_ERROR
                    "Could not find one of the required system commands for ESP target ${target}"
                    "Make sure you have dd, mkfs and mtools installed")
        endif ()

        # Parse options
        set(ov_options BOOT_FILE BLOCK_SIZE BLOCKS IMAGE_NAME)
        set(mv_options FILES)
        cmake_parse_arguments(CMX_ESP "" "${ov_options}" "${mv_options}" ${ARGN})

        # Handle default values
        if (NOT CMX_ESP_BOOT_FILE)
            message(FATAL_ERROR "ESP image target ${target} is missing BOOT_FILE property")
        endif ()
        if (NOT CMX_ESP_IMAGE_NAME)
            set(CMX_ESP_IMAGE_NAME "${target}")
        endif ()
        if (NOT CMX_ESP_BLOCK_SIZE)
            set(CMX_ESP_BLOCK_SIZE 512)
        endif ()
        if (NOT CMX_ESP_BLOCKS)
            set(CMX_ESP_BLOCKS 93750)
        endif ()

        message(STATUS "Configured ESP image for ${target} with ${CMX_ESP_BLOCKS} blocks, ${CMX_ESP_BLOCK_SIZE} bytes each")

        set(image_file "${CMX_ESP_IMAGE_NAME}.img")
        add_custom_target(${target} WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

        # Create an empty image file using dd and format to FAT32 using mkfs
        add_custom_command(
                TARGET ${target}
                COMMAND ${DD}
                ARGS if="/dev/zero" of="${image_file}" bs=${CMX_ESP_BLOCK_SIZE} count=${CMX_ESP_BLOCKS} iflag=fullblock
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                BYPRODUCTS ${image_file})
        add_custom_command(
                TARGET ${target}
                COMMAND ${MKFS}
                ARGS -F32 -n "EFIBOOT" "${image_file}"
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                BYPRODUCTS ${image_file})

        # Copy boot file into image
        add_custom_command(
                TARGET ${target}
                COMMAND ${MMD}
                ARGS -i "${image_file}" "::EFI"
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                BYPRODUCTS ${image_file})
        add_custom_command(
                TARGET ${target}
                COMMAND ${MMD}
                ARGS -i "${image_file}" "::EFI/BOOT"
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                BYPRODUCTS ${image_file})

        if (DEFINED CMX_CPU_64_BIT)
            set(boot_file_name "BOOTX64.EFI")
            message(STATUS "Using 64-bit EFI boot target")
        else ()
            set(boot_file_name "BOOTIA32.EFI")
            message(STATUS "Using 32-bit EFI boot target")
        endif ()

        add_custom_command(
                TARGET ${target}
                COMMAND ${MCOPY}
                ARGS -i "${image_file}" "${CMX_ESP_BOOT_FILE}" "::EFI/BOOT/${boot_file_name}"
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                BYPRODUCTS ${image_file})

        set(visited_paths "")
        # Copy optional files into image
        foreach (kv_pair IN LISTS CMX_ESP_FILES)
            if (NOT "${kv_pair}" MATCHES "(.+)=(.+)")
                message(WARNING "Malformed file pair in FILES parameter, skipping")
                continue()
            endif ()

            string(REPLACE "=" ";" values "${kv_pair}")
            list(GET values 0 source_path)
            list(GET values 1 target_path)

            # Recursively rebuild parent file path from the root to create directories
            cmake_path(GET target_path PARENT_PATH parent_path)
            if (NOT parent_path STREQUAL "")
                if ("${parent_path}" MATCHES ".*\/.*") # More than one component
                    string(REPLACE "/" ";" directories "${parent_path}")
                else () # Only one component, cheat a little
                    list(APPEND directories "${parent_path}")
                endif ()
                set(current_path "")
                foreach (directory IN ITEMS ${directories})
                    if (NOT "${current_path}" STREQUAL "")
                        set(current_path "${current_path}/${directory}")
                    else ()
                        set(current_path "${directory}")
                    endif ()
                    # If we already created this path, skip it since mmd will exit with an error
                    if ("${current_path}" IN_LIST visited_paths OR "${current_path}" MATCHES "([eE][fF][iI])(\/[bB][oO]{2}[tT])?")
                        continue()
                    endif ()
                    # Create directory and add path to list of visited paths
                    add_custom_command(
                            TARGET ${target}
                            COMMAND ${MMD}
                            ARGS -i "${image_file}" "::${current_path}"
                            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                            BYPRODUCTS ${image_file})
                    list(APPEND visited_paths "${current_path}")
                endforeach ()
            endif ()

            add_custom_command(
                    TARGET ${target}
                    COMMAND ${MCOPY}
                    ARGS -i "${image_file}" "${source_path}" "::${target_path}"
                    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                    BYPRODUCTS ${image_file})
        endforeach ()
    endmacro()

    macro(cmx_add_iso_image target)
        find_program(XORRISO "xorriso")
        find_program(MKDIR "mkdir")
        find_program(CP "cp")
        find_program(MV "mv")

        if (NOT XORRISO OR NOT MKDIR OR NOT CP OR NOT MV)
            message(FATAL_ERROR
                    "Could not find one of the required system commands for ISO target ${target}"
                    "Make sure you have mkdir, cp, mv and xorriso installed")
        endif ()

        # Parse options
        set(ov_options ESP_IMAGE ESP_IMAGE_NAME IMAGE_NAME)
        set(mv_options FILES)
        cmake_parse_arguments(CMX_ISO "" "${ov_options}" "${mv_options}" ${ARGN})

        # Handle default options
        if (NOT CMX_ISO_ESP_IMAGE)
            message(FATAL_ERROR "ISO image target ${target} is missing ESP_IMAGE property")
        endif ()
        if (NOT CMX_ISO_IMAGE_NAME)
            set(CMX_ISO_IMAGE_NAME "${target}")
        endif ()

        set(image_file "${CMX_ISO_IMAGE_NAME}.iso")
        add_custom_target(${target} WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

        # Create directory for composing the ISO file
        add_custom_command(
                TARGET ${target}
                COMMAND ${MKDIR}
                ARGS -p "${target}"
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

        # Copy system partition image
        if (NOT CMX_ISO_ESP_IMAGE_NAME)
            get_filename_component(esp_image_file ${CMX_ISO_ESP_IMAGE} NAME)
        else ()
            set(esp_image_file "${CMX_ISO_ESP_IMAGE_NAME}.img")
        endif ()
        set(esp_target_path "${target}/${esp_image_file}")

        add_custom_command(
                TARGET ${target}
                COMMAND ${CP}
                ARGS "${CMX_ISO_ESP_IMAGE}" "${esp_target_path}"
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

        # Copy optional files into ISO
        foreach (kv_pair IN LISTS CMX_ISO_FILES)
            if (NOT "${kv_pair}" MATCHES "(.+)=(.+)")
                message(WARNING "Malformed file pair in FILES parameter, skipping")
                continue()
            endif ()

            string(REPLACE "=" ";" values "${kv_pair}")
            list(GET values 0 source_path)
            list(GET values 1 target_path)

            # Recursively generate directories
            cmake_path(GET target_path PARENT_PATH parent_path)
            if (NOT parent_path STREQUAL "")
                add_custom_command(
                        TARGET ${target}
                        COMMAND ${MKDIR}
                        ARGS -p "${target}/${parent_path}"
                        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
            endif ()
            # Copy file
            add_custom_command(
                    TARGET ${target}
                    COMMAND ${CP}
                    ARGS "${source_path}" "${target_path}"
                    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
        endforeach ()

        # Add xorriso command for creating a bootable ISO from the target output directory
        add_custom_command(
                TARGET ${target}
                COMMAND ${XORRISO}
                ARGS -as mkisofs -V "EFI_ISO_BOOT" -e "${esp_image_file}" -no-emul-boot -o "${image_file}" "${target}/"
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                BYPRODUCTS ${image_file})
    endmacro()
endif ()