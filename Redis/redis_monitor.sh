#!/bin/bash
password="" # Redis password Here
host="" # Redis Host here
port="" # Redis Port here

for key in $(redis-cli --no-auth-warning -h $host -p $port -a "$password" keys \*);
do
        length=$(redis-cli --no-auth-warning -h $host -p $port -a '$password' llen $key | awk -F " " '{print $1}')
        echo "$key = $length"
done
# Once setup script Run the below command
# chmod +x redis_monitor.sh  - Excute permission 
# watch -n 1 "sh redis_monitor.sh"  - Monitor Redis every 1 Sec
