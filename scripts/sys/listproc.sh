
echo "Print all Processes and threads in the system"


pids=
for pid in $(ls -1 /proc | grep -E '^[0-9]+')
do
    if [ -f /proc/$pid/status ] ; then
        pids="$pids $pid"
        Threads=$(awk -F'\t' '/^Threads/ {print $2}' /proc/$pid/status)
        if [ XX$Threads != "XX" ] ; then
            if [ -d /proc/$pid/task ] ; then
                pids="$pids $(ls -1 /proc/$pid/task/ | grep -E '^[0-9]+')"
            fi
        fi
    fi
done

#echo $pids

printf "========================================================================\n"
printf "%-10s || %-10s || %10s (%5s) core:%s | vmsize=%s \n" "ThreadGroup" "Parent" "TName" "Tid"  "TCpus" "VmPeak"
printf "========================================================================\n\n"
for pid in $pids
#for pid in "139726"
do 
    if [ ! -f /proc/$pid/status ] ; then
        continue
    fi

    NGid=$(awk -F'\t' '/^Ngid/ {print $2}' /proc/$pid/status)
    TGid=$(awk -F'\t' '/^Tgid/ {print $2}' /proc/$pid/status)
    PPid=$(awk -F'\t' '/^PPid/ {print $2}' /proc/$pid/status)

    VmPeak=$(awk -F'\t' '/^VmPeak/ {print $2}' /proc/$pid/status)
    TName=$(awk -F'\t' '/^Name/ {print $2}' /proc/$pid/status)
    TCpus=$(awk -F'\t' '/^Cpus_allowed_list/ {print $2}' /proc/$pid/status)
    Tid=$(awk -F'\t' '/^Pid/ {print $2}' /proc/$pid/status)
    priority=$(awk '{print $18}' /proc/$pid/stat)
    nice=$(awk '{print $19}' /proc/$pid/stat)

    NumaGroup=$(awk -F'\t' '/^Name/ {print $2}' /proc/$NGid/status 2> /dev/null)
    ThreadGroup=$(awk -F'\t' '/^Name/ {print $2}' /proc/$TGid/status 2> /dev/null)
    Parent=$(awk -F'\t' '/^Name/ {print $2}' /proc/$PPid/status 2> /dev/null)

    #Thread=$(grep 'Name\|Cpus_allowed_list\|^Pid' /proc/$pid/status | tr -d '\t' | cut -d: -f2 | xargs -L3 | awk '{print $1,$2,$3}')

    #echo -e "${ThreadGroup} -> ${Parent} ->  ${TName} :: ${Tid} : ${TCpus} - ${VmPeak}"
    printf "%-10s -> %-10s -> %10s (%5s) core:%s : vmsize=%s no.Threads:%s pri: %s nice: %s\n" "${ThreadGroup}" "${Parent}" "${TName}" "${Tid}"  "${TCpus}" "${VmPeak}" "${Threads}" "${priority}" "${nice}"

done



#ps auxf  | awk '{ printf($6/1024 "MB\t"); printf($1 "\t"); for(i=11;i<=NF;++i) printf("%s ", $i);printf("\n")}'
