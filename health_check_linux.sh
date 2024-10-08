#! /bin/bash
TIME=$(date "+%Y-%m-%d %H:%M:%S")
echo -e "Time\t\t\tMemory\t\tDisk /root\tCPU"
seconds="3600"
end=$((SECONDS+seconds))
while [ $SECONDS -lt $end ]; do
MEMORY=$(free -m | awk 'NR==2{printf "%.f%%\t\t", $3*100/$2 }')
DISK=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')
#CPU=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')
CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf("%.f\n", 100 - $1)}')
echo -e "$TIME\t$MEMORY$DISK$CPU"
sleep 3
done
