#!/bin/bash

set -x -e

_SOURCE_CODES_DIR='/media/Source_Codes/Source_Codes'

_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${_WD}/tianocore_uefi_common.sh"

_UDK_BUILD_OUTER_DIR="${_UDK_DIR}/Build/EdkCompatibilityPkg/"
_UDK_BUILD_DIR="${_UDK_BUILD_OUTER_DIR}/DEBUG_GCC46/"

_EDKCOMPATIBILITYPKG_BUILD_DIR="${_BACKUP_BUILDS_DIR}/EDKCOMPATIBILITYPKG_BUILD"

_COMPILE_EDKCOMPATIBILITYPKG() {
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	cd "${_UDK_DIR}/"
	git checkout keshav_pr
	
	echo
	
	_COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_CORRECT_WERROR
	
	echo
	
	_APPLY_PATCHES
	
	echo
	
	_APPLY_CHANGES
	
	echo
	
	_COMPILE_BASETOOLS_MANUAL
	
	echo
	
	build -p "${_UDK_DIR}/EdkCompatibilityPkg/EdkCompatibilityPkg.dsc" -a X64 -b DEBUG -t GCC46
	
	echo
	
	cp -r "${_UDK_BUILD_DIR}" "${_EDKCOMPATIBILITYPKG_BUILD_DIR}"
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	# _SET_PYTHON3
	
	echo
	
}

echo

_COMPILE_EDKCOMPATIBILITYPKG

echo

unset _SOURCE_CODES_DIR
unset _WD
unset _UDK_DIR
unset _UDK_BUILD_TOOLS_DIR
unset _UDK_C_SOURCE_DIR
unset EDK_TOOLS_PATH
unset _EDKCOMPATIBILITYPKG_BUILD_DIR
unset _BACKUP_BUILDS_DIR

set +x +e
