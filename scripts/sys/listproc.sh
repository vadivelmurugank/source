#!/bin/bash

printf "====================================================================================\n"
printf "[%-5s] %-10s %-s (%-10s %-10s)  %-s : %-s  %-s %-s\n"  "PID"  "PROCESS"  "Threads#" "Parent" "ThreadGroup"  "Cpus" "VmPeak"  "priority" "nice"
printf "====================================================================================\n\n"

function print_pid() 
{
	type=$1
	pid=$2

    if [ ! -f /proc/$pid/status ] ; then
        return
    fi

	#echo "====> PID : $pid"


    NGid=$(awk -F'\t' '/^Ngid/ {print $2}' /proc/$pid/status)
    TGid=$(awk -F'\t' '/^Tgid/ {print $2}' /proc/$pid/status)
    PPid=$(awk -F'\t' '/^PPid/ {print $2}' /proc/$pid/status)

    Threads=$(awk -F'\t' '/^Threads/ {print $2}' /proc/$pid/status)
    VmPeak=$(awk -F'\t' '/^VmPeak/ {print $2}' /proc/$pid/status)
    TName=$(awk -F'\t' '/^Name/ {print $2}' /proc/$pid/status)
    TCpus=$(awk -F'\t' '/^Cpus_allowed_list/ {print $2}' /proc/$pid/status)
    Tid=$(awk -F'\t' '/^Pid/ {print $2}' /proc/$pid/status)
    priority=$(awk '{print $18}' /proc/$pid/stat)
    nice=$(awk '{print $19}' /proc/$pid/stat)

    NumaGroup=$(awk -F'\t' '/^Name/ {print $2}' /proc/$NGid/status 2> /dev/null)
    ThreadGroup=$(awk -F'\t' '/^Name/ {print $2}' /proc/$TGid/status 2> /dev/null)
    Parent=$(awk -F'\t' '/^Name/ {print $2}' /proc/$PPid/status 2> /dev/null)

	cmdstr=""
    if [ -f /proc/$pid/cmdline ] ; then
    	cmdstr="$(awk '{print $0}' /proc/$pid/cmdline | tr '\0' ' ')"
	fi

    if [ -f /proc/$pid/environ ] ; then
    	environ="$(awk '{print $0}' /proc/$pid/environ | tr '\0' ' ')"
	fi

    if [ -f /proc/$pid/cgroup ] ; then
    	cgroup="$(awk '{print $0}' /proc/$pid/cgroup | tr '\0' ' ')"
	fi

    #Thread=$(grep 'Name\|Cpus_allowed_list\|^Pid' /proc/$pid/status | tr -d '\t' | cut -d: -f2 | xargs -L3 | awk '{print $1,$2,$3}')

    #echo -e "${ThreadGroup} -> ${Parent} ->  ${TName} :: ${Tid} : ${TCpus} - ${VmPeak}"
	
	if [ $type == "parent" ] ; then
		printf "[%-5s] %-10s threads#%-s (Parent:%-10s Group:%-10s)  core:%-s : vmsize=%-s  pri=%-s nice=%-s\n"  "${Tid}"  "${TName}"  "${Threads}" "${Parent}" "${ThreadGroup}"  "${TCpus}" "${VmPeak}"  "${priority}" "${nice}"
    	printf "   cgroup: %-10s \n" "${cgroup}"
    	printf "   environ: %-50s\n" "${environ}"
    	printf "   %-50s\n\n" "${cmdstr}"
	else
		printf "   |--> [%-5s] %-10s (Parent:%-10s Group:%-10s) threads#%-s core:%-s : vmsize=%-s  pri=%-s nice=%-s\n"  "${Tid}"  "${TName}"  "${Parent}" "${ThreadGroup}" "${Threads}" "${TCpus}" "${VmPeak}"  "${priority}" "${nice}"
    	printf "        |-> cgroup: %-10s \n" "${cgroup}"
    	printf "        |-> environ: %-50s\n" "${environ}"
    	printf "        |-> %-50s\n\n" "${cmdstr}"
	fi
}

#ps auxf  | awk '{ printf($6/1024 "MB\t"); printf($1 "\t"); for(i=11;i<=NF;++i) printf("%s ", $i);printf("\n")}'

app="$1"
for pid in $(ls -1 /proc | grep -E '^[0-9]+')
do
	parentid=""
	childid=""
	ctids=""

	if ! [ -f /proc/$pid/status ] ; then
		continue
	fi

    TName=$(awk -F'\t' '/^Name/ {print $2}' /proc/$pid/status)
    if [ "X${app}" == "X" ] ; then
		parentid=$pid
	elif [[ "${TName}" =~ "$app" ]] ; then
		parentid=$pid
	fi

	if [ -n $parentid ] && [ -f /proc/$parentid/status ] ; then
		print_pid "parent" $parentid
        Threads=$(awk -F'\t' '/^Threads/ {print $2}' /proc/$parentid/status)
        if [ XX$Threads != "XX" ] && [[ $Threads > 1 ]] ; then
        	ctids="$(ls -1 /proc/$parentid/task/ | grep -E '^[0-9]+')"
        fi

		for childid in $ctids
		do 
			if [ -n $childid ] && [ -f /proc/$childid/status ] ; then
				print_pid "child" $childid
			fi
		done
    fi
done
