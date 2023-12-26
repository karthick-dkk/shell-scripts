#/bin/bash 
TIME=$(date "+%Y-%m-%d %H:%M:%S")
DATE=$(date "+%Y-%m-%d")
THRESHOLD1=80 # Alert Percentage only for CPU 
THRESHOLD2=80 # Alert Percentage only for RAM
CLIENT="44_server"
IP=`hostname -I | awk '{print $1}'`
log="/tmp/logs/monitor_${CLIENT}_${IP}_${DATE}.log"

# SFTP Server details
SFTP_USER="Linux_Mate"
SFTP_HOST="103.239.139.126"
SFTP_PORT="5726"
REMOTE_DIR="/upload/logs/"
SFTP_PASS="Cart@123"
# Local file to upload
LOCAL_FILE="/tmp/logs/*.log"

# Function to upload file to SFTP server

upload_to_sftp() {
    echo "Uploading file to SFTP server..."
 sshpass -p "$SFTP_PASS"   sftp -P $SFTP_PORT $SFTP_USER@$SFTP_HOST:$REMOTE_DIR <<EOF
        mput $LOCAL_FILE
        bye
EOF
    echo "Upload complete."
}

function show_ram_usage() {
    TOTAL_RAM=`free -h | grep "Mem" | awk '{print $2}'`
    AVAIL_RAM=`free -h | grep "Mem" | awk '{print $7}'`
    local USED_PERCENTAGE=$(free | grep Mem | awk '{printf "%.2f", ($3/$2) * 100}')
    if (( $(bc <<< "$USED_PERCENTAGE >= $THRESHOLD2") )); then # Check if the threshld meets
       echo -e "${TIME} ${IP} ALERT: RAM Total= $TOTAL_RAM, Avail= $AVAIL_RAM, Used= $USED_PERCENTAGE%" >> ${log}
    fi
   #echo -e "${TIME} Total RAM: $TOTAL_RAM, Avail RAM: $AVAIL_RAM, RAM used: $USED_PERCENTAGE%" >> monitor_`hostname`${FILE_TIME}.log
}

function show_cpu_usage() {
    CPU_USAGE=`top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf("%.f\n", 100 - $1)}'`
    CPU_TOTAL=`lscpu | grep -i "CPU(S)" | awk 'NR==1 {print $2}'`
    if (( "$CPU_USAGE >= $THRESHOLD1")); then
        echo -e "${TIME} ${IP} ALERT: CPU Used= $CPU_USAGE"% >> ${log}
   fi
     #echo "${TIME} CPU_TOTAL: $CPU_TOTAL, $CPU_USAGE"% >> monitor_`hostname`${FILE_TIME}.log
}

function show_disk_usage() {
    disk=`df -h | awk 'NR>1{print $6, $2, $4,$5}' | awk 'match($0, /([0-9.]+)%/) {percentage = substr($0, RSTART, RLENGTH - 1); if (percentage >= 50) printf "DISK: %s, Total: %s, Avail: %s, Used: %s \n ", $1, $2, $3, $4}' | sort -h |  grep -Eiv "run"`
#Percentage is 80 ;Only above 80% disk usage will print 
        echo -e "${TIME} ${IP} ALERT: DISK usage is above 80% for $disk" >> ${log}
}

show_disk_usage
show_ram_usage
show_cpu_usage
