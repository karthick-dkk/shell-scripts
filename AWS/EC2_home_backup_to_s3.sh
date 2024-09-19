#!/bin/bash
############ Pre-Requests ####################
# aws-cli should be installed and configured
##############################################

# Specify your S3 bucket name
S3_BUCKET=""

# Create the backup directory structure /home/backup
BACKUP_DIRECTORY="/backup"
LOG_PATH="/var/log/ec2-backup"
LOG_FILE="{$LOG_PATH}_$(date +"%Y%m%d").log
# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIRECTORY"

# Use cp to copy files from /etc to the backup directory
# Add your folders here like /etc , /home 
cp -r /etc "$BACKUP_DIRECTORY"
cp -r /home "$BACKUP_DIRECTORY"

# Create a tar file of the entire backup directory with the IP address as the filename
BACKUP_TAR_FILE="$BACKUP_DIRECTORY/_$(hostname -i | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b").tar.gz"
tar -czvf "$BACKUP_TAR_FILE" -C "$BACKUP_DIRECTORY" .

# Specify the S3 destination path: s3://bucket-name/test11/YYYY/MM/DD/
S3_DESTINATION="s3://$S3_BUCKET/ec2-config-backup/$(date +"%Y/%m/%d")/"

# Use AWS CLI to copy the backup tar file to S3 and capture the output
S3_COMMAND_OUTPUT=$(aws s3 cp "$BACKUP_TAR_FILE" "$S3_DESTINATION" 2>&1)

# Capture the exit status of the AWS CLI command
COPY_EXIT_STATUS=$?

# Check if the copy operation was successful
if [ $COPY_EXIT_STATUS -eq 0 ]; then
    STATUS="Success"
else
    STATUS="Failure"
fi

# Log the copy exit status, status, and AWS CLI output to the log file

echo "Status: $STATUS" >> "$LOG_FILE"
echo "$S3_COMMAND_OUTPUT" >> "$LOG_FILE"

# Clean up the backup directory and backup tar file
rm -rf "$BACKUP_DIRECTORY"

echo " Hey, Backup completed and uploaded to S3"
