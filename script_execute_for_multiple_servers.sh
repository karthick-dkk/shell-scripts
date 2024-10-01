#!/bin/bash
##### STEPS ######################
# 1. Create server list in server.txt
# 2. Execute the script
###################################
# Variables
FILE_TO_COPY="health_check_linux.sh"
USER="user" # <-- username here
PASSWORD=""  # <-- Password here
SERVER="servers.txt"  # <-- Server list here
COMMAND="health_check_linux.sh"
# Loop through each server in the server list
while IFS= read -r SERVER
do
    echo "Executing commnad  $SERVER ..."
    (
    # Use a subshell to send the password via stdin
    # scp -r  -o StrictHostKeyChecking=no "$FILE_TO_COPY" "$USER@$SERVER:$REMOTE_PATH"
   # We can sshpass to password authentication 
   ssh -o StrictHostKeyChecking=no "$USER@$SERVER" 'bash -s' < "$COMMAND"
)
    if [ $? -ne 0 ]; then
        echo "Failed to execute on $SERVER"
    fi
done < "$SERVER_LIST"
