# A modernized version of https://github.com/hiroaki-yamamoto/findefi
# with some additional features.
#
# @author Hiroaki Yamamoto
# @author Alexander Hinze

set(EFI_HEADERS_DIR "efi")
set(EFI_HEADERS_PROTOCOL_DIR "protocol")
set(EFI_HEADERS_ARCHITECTURE_DIR "${CMAKE_HOST_SYSTEM_PROCESSOR}")

set(EFI_HEADERS
        "efi.h"
        "efi_nii.h"
        "efi_pxe.h"
        "efiapi.h"
        "eficon.h"
        "efidebug.h"
        "efidef.h"
        "efidevp.h"
        "efierr.h"
        "efifs.h"
        "efigpt.h"
        "efilib.h"
        "efilink.h"
        "efinet.h"
        "efipart.h"
        "efipciio.h"
        "efiprot.h"
        "efipxebc.h"
        "efirtlib.h"
        "efiser.h"
        "efistdarg.h"
        "efiui.h"
        "libsmbios.h"
        "pci22.h"
        "romload.h")

set(EFI_HEADERS_PROTOCOL
        "adapterdebug.h"
        "eficonsplit.h"
        "efidbg.h"
        "efivar.h"
        "intload.h"
        "legacyboot.h"
        "piflash64.h"
        "vgaclass.h")

set(EFI_HEADERS_ARCHITECTURE "efibind.h" "efilibplat.h" "pe.h")
set(EFI_LIBRARIES "efi" "gnuefi")

foreach (header IN LISTS EFI_HEADERS EFI_HEADERS_ARCHITECTURE EFI_HEADERS_PROTOCOL)
    find_path(INTERNAL_HEADERS_DIR "${header}"
            PATH_SUFFIXES
            "${EFI_HEADERS_DIR}" "${EFI_HEADERS_DIR}/${EFI_HEADERS_ARCHITECTURE_DIR}"
            "${EFI_HEADERS_DIR}/${EFI_HEADERS_PROTOCOL_DIR}")
    list(FIND EFI_INCLUDE_DIR ${INTERNAL_HEADERS_DIR} result)
    if (result EQUAL -1)
        list(APPEND EFI_INCLUDE_DIR ${INTERNAL_HEADERS_DIR})
    endif (result EQUAL -1)
    unset(INTERNAL_HEADERS_DIR CACHE)
endforeach (header)

foreach (library IN LISTS EFI_LIBRARIES)
    find_library(INTERNAL_LIBRARIES "${library}")
    list(FIND EFI_LIBRARIES_DIR ${INTERNAL_LIBRARIES} result)
    if (result EQUAL -1)
        list(APPEND EFI_LIBRARIES_DIR ${INTERNAL_LIBRARIES})
    endif (result EQUAL -1)
    unset(INTERNAL_LIBRARIES_DIR CACHE)
endforeach (library)

find_file(EFI_CRT "crt0-efi-${CMAKE_HOST_SYSTEM_PROCESSOR}.o" HINTS "/usr/lib" "/lib")
find_file(EFI_LD_SCRIPT "elf_${CMAKE_HOST_SYSTEM_PROCESSOR}_efi.lds" HINTS "/usr/lib" "/lib")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(EFI
        REQUIRED_VARS
        EFI_INCLUDE_DIR EFI_CRT EFI_LIBRARIES_DIR EFI_LD_SCRIPT
        VERSION_VAR MODULE_VERSION
        HANDLE_COMPONENTS
)
