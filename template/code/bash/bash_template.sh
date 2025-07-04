#!/bin/bash
set +x

#
# Usage of debug script
#
print_help() {
    cat <<EOF

    debug program executes sample python debug routines from specified debug module directory

        Run debug standalone script
        ----------------------------

            debug.sh [hasdcz] [--path] [--runcmd <cmd>] ..

                noarg           : start to interactive mode
                "-h"            : print this help
                "-a"            : runall commands non-interactive
                "-c"            : clear all/port counters
                "-s"            : show  all/port counters
                "-d"            : show  only drop counters
                "-t"            : show  tables, action and fields
                "-z"            : zip all log files
                "--port <port>" : specific port
                "--runcmd <cmd>": run debug command
                "--path <dir>"  : specify debugpath, default is current dir
                "--showzeros"   : show all zeros values, default is non-zero

                "--dbglist"    : list dbgshot triggers
                "--dbgdump"    : dump dbgshot data
                "--dbgclear"   : clear dbgshots
                "--dbg"        : "ingress", "egress", "ghost" dbgshot
                "--dbgtrig" <trigger> <value>  : dbgshot trigger name
                "--dbgval"  <value>            : dbgshot trigger value

EOF
}


# Check ENV env
check_env() {

    if [ -z ${ENV} ]; then
        echo "Error: Set ENV env variable"
        exit 1
    else
        if ! test -d "${ENV}" ; then
            echo "Error: ${ENV} is not a directory"
            exit 1
        fi
    fi

}

check_env
cmd=${ENV}/run_cmd.sh
DBG_START=DBGstart.py
IN=true
COLLECDBGILE=false
RUNALLCMDS=false
CLEARCOUNTER=false
SHOWCOUNTER=false
DROPCOUNTER=false
SHOWTABLES=false
RUNCMD=""
DBGDPATH=""
PIPE_ARG=$ENV/.pipearg
set_debug_env() {
    # PYTHON PATHS
    PYTHONPATH=${DBGDPATH}
}

# Check for debug script location
check_DBGdpath() {

    if [ -z  ${DBGDPATH} ] ; then
        if [ -z ${debug} ] ; then
            DBGDPATH=$(pwd)
        else
            DBGDPATH=${debug}
        fi
    fi

    if test -d "${DBGDPATH}" ; then
        echo "Source ${DBGDPATH}"
    else
        echo "Error: debug directory not present"
        print_help ; exit
    fi

    if ! test -f "${DBGDPATH}/${DBG_START}" ; then
       echo "Error: ${DBGDPATH}/${DBG_START} does not exist"
       exit
    fi
}

SHOWZEROS=false
dbgDUMP=false
dbgLIST=false
dbgCLEAR=false
dbg=false
dbgTRIG=""
dbgVAL=""
dbgDIR=""

OPTS=$(getopt -o hadzcst --long "port:","showzeros","dbg:","dbgtrig:","dbgval:","dbglist","dbgdump","dbgclear","runcmd:","path:" "" "$@")
eval set -- "$OPTS"

ENBOPTIONS=false
if [ "$#" -gt 2 ] ; then
    ENBOPTIONS=true
fi

while true;
do
    case "$1" in
        -h)  print_help; exit 0 ;;
        -z)  shift 1 ; IN=false ; COLLECDBGILE=true ;;
        -a)  shift 1 ; IN=false ; RUNALLCMDS=true ;;
        -c)
            shift 1 ; IN=false ; CLEARCOUNTER=true ;
            ;;
        -d)
            shift 1 ; IN=false ; DROPCOUNTER=true ;
            ;;
        -t)
            shift 1 ; IN=false ; SHOWTABLES=true ;
            ;;
        -s)
            shift 1 ; IN=false ; SHOWCOUNTER=true ;
            ;;
        --port)
            shift 1 ; IN=false ; PORTNAME=$1 ; shift 1
            ;;
        --showzeros)
            shift 1 ; IN=false ; SHOWZEROS=true ;
            ;;
        --dbgdump)
            shift 1 ; IN=false ; dbgDUMP=true ;
            ;;
        --dbgclear)
            shift 1 ; IN=false ; dbgCLEAR=true ;
            ;;
        --dbglist)
            shift 1 ; IN=false ; dbgLIST=true ;
            ;;
        --dbg)
            shift 1 ; IN=false ; dbg=true
            dbgDIR=$1 ; shift 1 ;
            ;;
        --dbgtrig)
            shift 1 ; IN=false ; dbg=true
            dbgTRIG=$1 ; shift 1 ;
            ;;
        --dbgval)
            shift 1 ; IN=false ; dbg=true
            dbgVAL=$1 ; shift 1 ;
            ;;
        --runcmd)
            shift 1 ; IN=false ; RUNCMD=$1 ; shift 1
            ;;
        --path)
            shift 1 ; DBGDPATH=$1 ; shift 1
            ;;
        --)
            shift 1
            break
            ;;
    esac
done
generate_yaml() {

DBGDYML=${ENV}/.debug.yml
sudo /bin/rm -rf ${DBGDYML}

sudo cat << EOF > ${DBGDYML}
#######################
# debug yaml file
#######################
debug:
    path: ${DBGDPATH}
    optenb : ${ENBOPTIONS}
    options:
        runall: ${RUNALLCMDS}
        tables:
            showtbl: ${SHOWTABLES}
        counters:
            clearcntr: ${CLEARCOUNTER}
            showcntr: ${SHOWCOUNTER}
            dropcntr: ${DROPCOUNTER}
            port: ${PORTNAME}
            showzeros: ${SHOWZEROS}
        dbgshot:
            dbg: ${dbg}
            dbgdir: ${dbgDIR}
            dbgtrig: ${dbgTRIG}
            dbgval:  ${dbgVAL}
            dbgdump: ${dbgDUMP}
            dbgclear: ${dbgCLEAR}
            dbglist: ${dbgLIST}
        zip: ${COLLECDBGILE}
        runcmd: ${RUNCMD}
EOF
#cat ${DBGDYML}
}

check_DBGdpath
generate_yaml
set_debug_env


#echo "PYTHONPATH - $PYTHONPATH"
INTERACTIVE=""
if $IN ; then
    INTERACTIVE=" -i"
fi

exec ${cmd} -b ${DBGDPATH}/${DBG_START} ${INTERACTIVE}
