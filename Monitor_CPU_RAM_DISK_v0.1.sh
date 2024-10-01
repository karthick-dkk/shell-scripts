#! /bin/bash
IP=`hostname -I`
#TIME=$(date "+%Y-%m-%d %H:%M:%S")
echo -e "CPU\tMemory\tDisk\tHostUpTime\tIP"
MEMORY=$(free -m | awk 'NR==2{printf "%.f%%\t", $3*100/$2 }')
DISK=$(df -h | awk '$NF=="/"{printf "%s\t", $5}')
CPU=`echo "$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf("%.f\n", 100 - $1)}')%"`
SYSTEM_UPTIME=`uptime | sed -E 's/.*up ([0-9]+) days, ([0-9]+):[0-9]+,.*/\1 days and \2 mins/'`
echo -e "$CPU\t$MEMORY$DISK\t$SYSTEM_UPTIME\t$IP"  
