################################################
# defs.inc

MAKEDIR=$(HOME)/github/source/build

# Python Paths
PYTHON=python2
PYTHON3=python3


# ROOT_PATH
TOOL_BASE=/tools/bin

STRACE_BIN=/usr/bin/strace
PSTACK_BIN=/usr/bin/pstack
LTRACE_BIN=/usr/bin/ltrace

XXD_BIN=${TOOLS_PATH}/xxd
OBJCOPY_BIN=${TOOLS_PATH}/objcopy

# Write creating it with windriver env variables
WRS_PATH=/projects/ntsw-sw3/linux/wrslinux_2.0
   
# host cross settings 
PPC_HOST_CROSS_PATH=${WRS_PATH}/gto/glibc_std/host-cross/powerpc-wrs-linux-gnu/x86-linux2
MIPS_HOST_CROSS_PATH=${WRS_PATH}/nsx/glibc_std/host-cross/mips-wrs-linux-gnu/x86-linux2
ARM_HOST_CROSS_PATH=${WRS_PATH}/arm
X86_HOST_CROSS_PATH=/usr/bin
X86_64_HOST_CROSS_PATH=/usr/bin

