#!/bin/bash
set -x

export CSCOPE_BIN=/usr/bin/cscope
export TMPDIR=$HOME/temp
export FOLLOW="-follow"

export CSCOPEVER=OS

function make_cscope_db()
{
    #cscope database
    echo "Creating cscope db ..."
    echo "Source location: ${SOURCE_LOC}"
    echo "cleanup prev cscope residues @ ${SOURCE_LOC}/cscope_build"
    rm -rf ${CSCOPE_LOC}/*
    mkdir -p  ${CSCOPE_LOC}
    mkdir -p  ${TMPDIR}
    find ${SOURCE_LOC} ${FOLLOW} \( -name "*.[ich]" -o   \
                 -name "*.cmd" -o        \
                 -name "*.mk" -o        \
                 -name "*.cc" -o        \
                 -name "*.go" -o        \
                 -name "*.cpp" -o       \
                 -name "*.p4" -o       \
                 -name "*.p4pp" -o       \
                 -name "*.include" -o   \
                 -name "*.asm" -o       \
                 -name "*.s" -o       \
                 -name "*.S" -o       \
                 -name "*.i" -o       \
                 -name "*.inc" -o       \
                 -name "*.yy" -o         \
                 -name "*.py" -o         \
                 -name "*.lex" -o        \
                 -name "*.cxx" -o        \
                 -name "*.inc" -o        \
                 -name "[mM]akefile" -o  \
                 -name "[mM]ake.*" -o  \
                 -name "*.mk" -o  \
                 -name "*.bzl" -o  \
                 -name "*.cmake" -o  \
                 -name "CMakeLists.*" -o  \
                 -name "*.mak" -o  \
                 -name "*.sdl" -o  \
                 -name "*.cif" -o  \
                 -name "defs[-.]*" -o    \
                 -name "rules[-.]*" -o   \
                 -name "*.*_c"   -o      \
                 -name "*.sig" -o           \
                 -name "*.bld" -o          \
                 -name "*.pl" \
                 -name "*.ddl" \
                 -name "*.cdf" \
                 -name "*.hpp" \) \
                 -exec readlink -f {} \; \
                > ${CSCOPE_LOC}/cscope.files
    #R-recursive u-unconditional b-build reference q-quick search
                 #-not '(' -path '*/third-party/*' -prune ')' \
    cd ${CSCOPE_LOC}
    ${CSCOPE_BIN} -Rbq
    cd -
    echo "Cscope created at ${CSCOPE_LOC}... Done."
}
export -f make_cscope_db

echo "$#"
if [ "$#" -eq 0 ]
then
    export SOURCE_LOC=$(pwd)
    mkdir $(pwd)/cscope_build
    export CSCOPE_LOC=$(pwd)/cscope_build

else

    if [ $1 == "kernel" ]
    then
        export WS_ROOT=/auto//kernel/wrl8
        export KERNEL_SOURCE=${WS_ROOT}
        SOURCE_LOC=${KERNEL_SOURCE}
        CSCOPE_LOC=${WS_ROOT}/build
    else
        export SOURCE_LOC=$(pwd)/$1
        mkdir $(pwd)/cscope_build
        export CSCOPE_LOC=$(pwd)/cscope_build
    fi

fi

make_cscope_db

