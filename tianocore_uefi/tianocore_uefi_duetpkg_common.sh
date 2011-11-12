#!/bin/bash

set -x -e

_SOURCE_CODES_DIR='/media/Source_Codes/Source_Codes'

_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${_WD}/tianocore_uefi_common.sh"

_UDK_DUETPKG_BOOTSECT_BIN_DIR="${_UDK_DIR}/DuetPkg/BootSector/bin/"
_UDK_BUILD_OUTER_DIR="${_UDK_DIR}/Build/DuetPkgX64/"
_UDK_BUILD_DIR="${_UDK_BUILD_OUTER_DIR}/RELEASE_GCC46/"

_DUETPKG_EMUVARIABLE_BUILD_DIR="${_BACKUP_BUILDS_DIR}/DUETPKG_EMUVARIABLE_BUILD"
_DUETPKG_FSVARIABLE_BUILD_DIR="${_BACKUP_BUILDS_DIR}/DUETPKG_FSVARIABLE_BUILD"

_DUET_BUILDS_DIR="${_SOURCE_CODES_DIR}/Firmware/UEFI/Tianocore_UEFI_DUET_Builds/"
_UEFI_DUET_INSTALLER_DIR="${_DUET_BUILDS_DIR}/Tianocore_UEFI_DUET_Installer_GIT/"
_DUET_MEMDISK_COMPILED_DIR="${_DUET_BUILDS_DIR}/Tianocore_UEFI_DUET_memdisk_compiled_GIT/"
_DUET_MEMDISK_TOOLS_DIR="${_DUET_BUILDS_DIR}/Tianocore_UEFI_DUET_memdisk_tools_GIT/"

_MIGLE_BOOTDUET_COMPILE_DIR="${_SOURCE_CODES_DIR}/Firmware/UEFI/Tianocore_UEFI_DUET_3rd_Party_Projects/migle_BootDuet_GIT"
_ROD_SMITH_DUET_INSTALL_DIR="${_SOURCE_CODES_DIR}/Firmware/UEFI/Tianocore_UEFI_DUET_3rd_Party_Projects/Rod_Smith_duet-install_my_GIT"

_BOOTPART="/boot/"
_UEFI_SYS_PART="/boot/efi/"
_SYSLINUX_LIB_DIR="/usr/lib/syslinux/"

_DUET_PART_FS_UUID="5FA3-2472"
_DUET_PART_MP="/media/DUET"

_MIGLE_BOOTDUET_CLEAN() {
	
	echo
	
	cd "${_MIGLE_BOOTDUET_COMPILE_DIR}/"
	make clean
	
	echo
	
}

_MIGLE_BOOTDUET_COMPILE() {
	
	echo
	echo "Compiling Migle's BootDuet"
	echo
	
	_MIGLE_BOOTDUET_CLEAN
	
	echo
	
	make
	make lba64
	make hardcoded-drive
	
	echo
	
}

_POST_DUET_MEMDISK() {
	
	echo
	
	"${_WD}/duetpkg_x86_64_create_memdisk_old.sh"
	
	echo
	
}

_COPY_MEMDISK_SYSLINUX() {
	
	echo
	
	sudo rm -f "${_BOOTPART}/memdisk_syslinux" || true
	sudo install -D -m644 "${_SYSLINUX_LIB_DIR}/memdisk" "${_BOOTPART}/memdisk_syslinux"
	
	echo
	
}

_COPY_EFILDR_MEMDISK() {
	
	echo
	
	sudo rm -f "${_BOOTPART}/Tianocore_UEFI_UDK_DUET_X86_64.img" || true
	sudo install -D -m644 "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/floppy.img" "${_BOOTPART}/Tianocore_UEFI_UDK_DUET_X86_64.img"
	
	echo
	
}

_COPY_EFILDR_DUET_PART() {
	
	echo
	
	if [[ -d "${_DUET_PART_MP}" ]]
	then
		sudo umount "${_DUET_PART_MP}" || true
	else
		sudo mkdir -p "${_DUET_PART_MP}"
	fi
	
	sudo mount -t vfat -o rw,users,exec -U "${_DUET_PART_FS_UUID}" "${_DUET_PART_MP}"
	sudo rm -f "${_DUET_PART_MP}/EFILDR20" || true
	sudo install -D -m644 "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/FV/Efildr20" "${_DUET_PART_MP}/EFILDR20"
	sudo umount "${_DUET_PART_MP}"
	
	echo
	
}

_COPY_UEFI_SHELL_UEFI_SYS_PART() {
	
	echo
	
	sudo rm -f "${_UEFI_SYS_PART}/shellx64.efi" || true
	sudo rm -f "${_UEFI_SYS_PART}/shellx64_old.efi" || true
	
	echo
	
	sudo install -D -m644 "${_UDK_DIR}/ShellBinPkg/UefiShell/X64/Shell.efi" "${_UEFI_SYS_PART}/shellx64.efi"
	sudo install -D -m644 "${_UDK_DIR}/EdkShellBinPkg/FullShell/X64/Shell_Full.efi" "${_UEFI_SYS_PART}/shellx64_old.efi"
	
	echo
	
}
