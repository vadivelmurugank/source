
    # regenerate module dependencies
    #depmod -a
    kmod list
    
    # kernel module /dev nodes
    kmod static-nodes

    lsmod

    # List Module Parameters
    #modinfo <modulename>

    # List all Module sections
    #systool -vm <modulename>

    for i in `lsmod | awk '{print $1}'`; do echo "$i: "; modinfo  $i | grep "" ; done 
    
    for mod in `lsmod | awk '{print $1}'`; do echo -e \"$mod\", \"$(modinfo -F description $mod)\", \"$(modinfo -F filename $mod)\" , \"$(modinfo -F license $mod)\" , \"$(modinfo -F parm $mod)\" , \"$(modinfo -F depends $mod)\" ; done 

    uname -a
    cat /proc/version
  
    # kernel bootline 
    cat /proc/cmdline 

    # Kernel config
    cat /boot/config-$(uname -r)

