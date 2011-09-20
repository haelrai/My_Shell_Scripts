#!/bin/bash

set -x -e

_SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"
_BACKUP_BUILDS_DIR="${_WD}/BACKUP_BUILDS"

_UDK_DIR="${_WD}/UDK_GIT"
_UDK_BUILD_TOOLS_DIR="${_WD}/buildtools-BaseTools_GIT"

export EDK_TOOLS_PATH="${_UDK_DIR}/BaseTools"

_UDK_C_SOURCE_DIR="${_UDK_BUILD_TOOLS_DIR}/Source/C"

_UDK_TOOLS_PATH_CLEAN() {
	
	rm -rf "${EDK_TOOLS_PATH}" || true
	
}

_UDK_BUILD_CLEAN() {
	
	echo
	
	_UDK_TOOLS_PATH_CLEAN
	
	echo
	
	rm -rf "${_UDK_BUILD_OUTER_DIR}" || true
	rm -rf "${_UDK_DIR}/Build" || true
	rm -rf "${_UDK_DIR}/Conf" || true
	
	echo
	
	cd "${_UDK_DIR}/"
	git reset --hard
	git checkout keshav_pr
	
	echo
	
}

_COPY_BUILDTOOLS_BASETOOLS() {
	
	echo
	
	_UDK_TOOLS_PATH_CLEAN
	
	echo
	
	cd "${_UDK_BUILD_TOOLS_DIR}/"
	
	echo
	
	git reset --hard
	
	echo
	
	git checkout master
	
	echo
	
	git merge remotes/origin/master
	
	echo
	
	cd "${_UDK_DIR}/"
	
	echo
	
	cp -r "${_UDK_BUILD_TOOLS_DIR}" "${EDK_TOOLS_PATH}"
	
	echo
	
}

_COMPILE_BASETOOLS_MANUAL() {
	
	echo
	
	cd "${_UDK_DIR}/"
	source "${_UDK_DIR}/edksetup.sh" BaseTools
	
	echo
	
	cd "${_UDK_DIR}/"
	make -C "${_UDK_DIR}/BaseTools"
	
	echo
	
}

_CORRECT_WERROR() {
	
	echo
	
	sed 's|-Werror |-Wno-error -Wno-unused-but-set-variable |g' -i "${_UDK_DIR}/BaseTools/Source/C/Makefiles/header.makefile"
	sed 's|-Werror |-Wno-error -Wno-unused-but-set-variable |g' -i "${_UDK_DIR}/BaseTools/Conf/tools_def.template"
	sed 's|--64 | |g' -i "${_UDK_DIR}/BaseTools/Conf/tools_def.template"
	
	echo
	
}

_SET_PYTHON2() {
	
	echo
	
	# _PYTHON_="$(which python)"
	# sudo rm -f "${_PYTHON_}"
	# sudo ln -s "$(which python2)" "${_PYTHON_}"
	# unset _PYTHON_
	
	# export PYTHON="python2"
	
	echo
	
	sed 's|python |python2 |g' -i "${_UDK_DIR}/BaseTools/BinWrappers/PosixLike/RunToolFromSource"
	sed 's|python |python2 |g' -i "${_UDK_DIR}/BaseTools/BinWrappers/PosixLike/RunBinToolFromBuildDir"
	sed 's|python |python2 |g' -i "${_UDK_DIR}/BaseTools/BinWrappers/PosixLike/GenDepex"
	
	echo
	
	sed 's|python |python2 |g' -i "${_UDK_DIR}/BaseTools/Tests/GNUmakefile"
	
	echo
	
}

_SET_PYTHON3() {
	
	echo
	
	_PYTHON_="$(which python)"
	sudo rm -f "${_PYTHON_}"
	sudo ln -s "$(which python3)" "${_PYTHON_}"
	unset _PYTHON_
	
	# export PYTHON="python3"
	
	echo
	
}

_APPLY_PATCHES() {
	
	echo
	
}

_APPLY_CHANGES() {
	
	echo
	
	## DuetPkg
	# sed 's|#define EFI_PAGE_BASE_OFFSET_IN_LDR 0x70000|#define EFI_PAGE_BASE_OFFSET_IN_LDR 0x80000|g' -i "${EDK_TOOLS_PATH}/Source/C/GenPage/GenPage.c" || true
	
	## EmulatorPkg
	sed 's|export LIB_ARCH_SFX=64|export LIB_ARCH_SFX=""|g' -i "${_UDK_DIR}/EmulatorPkg/build.sh"
	# sed 's|UNIXPKG_TOOLS=GCC44|UNIXPKG_TOOLS=GCC45|g' -i "${_UDK_DIR}/EmulatorPkg/build.sh"
	
	echo
	
}
