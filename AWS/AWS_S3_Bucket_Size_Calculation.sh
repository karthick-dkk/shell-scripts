#!/bin/bash
######## Pre-Request ######
# aws-cli should be installed
# aws configure - Should be configured
############################
# File containing S3 bucket names (one per line)
aws s3 ls | awk '{print $3 }' > buckets.txt
BUCKET_FILE="buckets.txt"  # Modify the bucket names here
date=`date +%Y-%m-%d`
output_file="s3_bucket"    # output file here

# Use the AWS CLI to list folders (common prefixes) inside each S3 bucket
while read -r S3_BUCKET; do
  # List folders inside the S3 bucket
  folders=$(aws s3 ls "s3://$S3_BUCKET/" | grep PRE | awk '{print $2}' | sort -u)

  # Iterate through and print each folder name
  for folder in $folders; do
    # Replace slashes (/) with underscores (_) in bucket and folder names
    sanitized_bucket_name=$(echo "$S3_BUCKET" | tr / _)
    sanitized_folder_name=$(echo "$folder" | tr / _)

    # Create filenames with sanitized names
    bucket_filename="${sanitized_bucket_name}.txt"
    folder_filename="${sanitized_bucket_name}_${sanitized_folder_name}.txt"

    echo "s3://$S3_BUCKET/$folder"
    # Save the output to the appropriately named files
    #aws s3 ls "s3://$S3_BUCKET" --recursive --human-readable --summarize >> "$bucket_filename"
    aws s3 ls "s3://$S3_BUCKET/$folder" --recursive --human-readable --summarize >> "$folder_filename"
  done
done < "$BUCKET_FILE" 
####Output File
sleep 10
grep " Total Size:" * > {$output_file}_{$date}.log

####Delete the files#####
sleep 10

grep " Total Size:" * | awk -F":" '{print$1}' > deletion
#### Uncomment the below line for delete the log files
sed  's/^/rm -rf /' deletion > delete_file && sh delete_file

#######Script End#########
