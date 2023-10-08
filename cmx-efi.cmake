include_guard()

include(ProcessorCount)
ProcessorCount(EFI_NUM_THREADS)

# FIXME: RISCV support disabled for now due to https://sourceforge.net/p/gnu-efi/bugs/36/ re-appearing

set(CMX_GNUEFI_VERSION "3.0.17")
set(CMX_GNUEFI_CHECKSUM "832496719182e7d6a4b12bc7c0b534d2")
set(CMX_GNUEFI_FETCHED OFF)

if ("${CMX_CPU_ARCH}" STREQUAL "x86_64")
    set(EFI_HOST_ARCH "x86_64")
elseif ("${CMX_CPU_ARCH}" STREQUAL "x86")
    set(EFI_HOST_ARCH "i386")
elseif ("${CMX_CPU_ARCH}" STREQUAL "arm64")
    set(EFI_HOST_ARCH "armv8")
elseif ("${CMX_CPU_ARCH}" STREQUAL "arm")
    set(EFI_HOST_ARCH "armv7")
    # elseif ("${CMX_CPU_ARCH}" STREQUAL "riscv64")
    #     set(EFI_HOST_ARCH "riscv64")
else ()
    message(FATAL_ERROR "CPU architecture ${CMX_CPU_ARCH} is not supported right now")
endif ()

if (NOT EFI_TARGET_ARCH)
    message("No target architecture specified for GNU-EFI, defaulting to ${CMX_CPU_ARCH}")
    set(EFI_TARGET_ARCH "${CMX_CPU_ARCH}")
endif ()

if ("${EFI_TARGET_ARCH}" STREQUAL "x86_64")
    set(EFI_BUILD_DIR_NAME "x86_64")
elseif ("${EFI_TARGET_ARCH}" STREQUAL "x86")
    set(EFI_BUILD_DIR_NAME "ia32")
elseif ("${EFI_TARGET_ARCH}" STREQUAL "arm64")
    set(EFI_BUILD_DIR_NAME "aarch64")
elseif ("${EFI_TARGET_ARCH}" STREQUAL "arm")
    set(EFI_BUILD_DIR_NAME "arm")
    # elseif ("${EFI_TARGET_ARCH}" STREQUAL "riscv64")
    #     set(EFI_BUILD_DIR_NAME "riscv64")
else ()
    message(FATAL_ERROR "CPU architecture ${EFI_TARGET_ARCH} is not supported right now")
endif ()

if (NOT CMX_GNUEFI_FETCHED)
    FetchContent_Declare(
            gnuefi
            URL "https://deac-ams.dl.sourceforge.net/project/gnu-efi/gnu-efi-${CMX_GNUEFI_VERSION}.tar.bz2"
            URL_HASH MD5=${CMX_GNUEFI_CHECKSUM}
    )
    FetchContent_MakeAvailable(gnuefi)
    set(CMX_GNUEFI_FETCHED ON)
endif () # CMX_GNUEFI_FETCHED

macro(cmx_add_efi target arch)
    find_program(MAKE "make")
    if (NOT MAKE)
        message(FATAL_ERROR "Could not find make, make sure it's installed")
    endif ()

    if ("${arch}" STREQUAL "x86_64")
        set(target_arch "x86_64")
        if (NOT "${EFI_HOST_ARCH}" STREQUAL "${target_arch}")
            set(cross_compile "x86_64-linux-gnu-")
        endif ()
    elseif ("${arch}" STREQUAL "x86")
        set(target_arch "i386")
        if (NOT "${EFI_HOST_ARCH}" STREQUAL "${target_arch}")
            set(cross_compile "i686-linux-gnu-")
        endif ()
    elseif ("${arch}" STREQUAL "arm64")
        set(target_arch "armv8")
        if (NOT "${EFI_HOST_ARCH}" STREQUAL "${target_arch}")
            set(cross_compile "aarch64-linux-gnu-")
        endif ()
    elseif ("${arch}" STREQUAL "arm")
        set(target_arch "armv7")
        if (NOT "${EFI_HOST_ARCH}" STREQUAL "${target_arch}")
            set(cross_compile "arm-linux-gnueabihf-")
        endif ()
        # elseif ("${arch}" STREQUAL "riscv64")
        #     set(target_arch "riscv64")
        #     if (NOT "${EFI_HOST_ARCH}" STREQUAL "${target_arch}")
        #         set(cross_compile "riscv64-linux-gnu-")
        #     endif ()
    else ()
        message(FATAL_ERROR "CPU architecture ${arch} is not supported right now")
    endif ()

    message(STATUS "Setting up GNU-EFI for ${target_arch}..")
    if (cross_compile)
        execute_process(COMMAND ${CMAKE_COMMAND} -E env
                HOSTARCH=${EFI_HOST_ARCH}
                ARCH=${target_arch}
                CROSS_COMPILE=${cross_compile}
                ${MAKE} -j ${EFI_NUM_THREADS} -f "${gnuefi_SOURCE_DIR}/Makefile"
                WORKING_DIRECTORY ${gnuefi_BINARY_DIR}
                OUTPUT_QUIET)
    else ()
        execute_process(COMMAND ${CMAKE_COMMAND} -E env
                HOSTARCH=${EFI_HOST_ARCH}
                ARCH=${target_arch}
                ${MAKE} -j ${EFI_NUM_THREADS} -f "${gnuefi_SOURCE_DIR}/Makefile"
                WORKING_DIRECTORY ${gnuefi_BINARY_DIR}
                OUTPUT_QUIET)
    endif ()
endmacro()

cmx_add_efi(efi-x86-64 x86_64)
cmx_add_efi(efi-x86 x86)
cmx_add_efi(efi-arm64 arm64)
cmx_add_efi(efi-arm arm)
# cmx_add_efi(efi-riscv64 riscv64)

set(EFI_TARGET_BUILD_DIR "${gnuefi_BINARY_DIR}/${EFI_BUILD_DIR_NAME}")
find_file(EFI_CRT "crt0-efi-${CMAKE_HOST_SYSTEM_PROCESSOR}.o"
        PATHS "${EFI_TARGET_BUILD_DIR}/gnuefi"
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_FIND_ROOT_PATH
        NO_CMAKE_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_DEFAULT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH)
if (NOT EFI_CRT)
    message(FATAL_ERROR "Could not find GNU-EFI CRT")
endif ()
find_file(EFI_LD_SCRIPT "elf_${CMAKE_HOST_SYSTEM_PROCESSOR}_efi.lds"
        PATHS "${gnuefi_SOURCE_DIR}/gnuefi"
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_FIND_ROOT_PATH
        NO_CMAKE_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_DEFAULT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH)
if (NOT EFI_LD_SCRIPT)
    message(FATAL_ERROR "Could not find GNU-EFI LD script")
endif ()
find_file(EFI_LIBRARY "libgnuefi.a"
        PATHS "${EFI_TARGET_BUILD_DIR}/gnuefi"
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_FIND_ROOT_PATH
        NO_CMAKE_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_DEFAULT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH)
if (NOT EFI_LIBRARY)
    message(FATAL_ERROR "Could not find GNU-EFI library")
endif ()

macro(cmx_include_efi target access)
    cmx_set_freestanding(${target} ${access})
    target_include_directories(${target} ${access} "${gnuefi_SOURCE_DIR}/inc")
    target_link_options(${target} ${access} -T${EFI_LD_SCRIPT} ${EFI_CRT})
    target_link_libraries(${target} ${access} ${EFI_LIBRARY})
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