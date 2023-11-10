#!/bin/bash
####################
#Author: Karthick D
#Author Email: karthidkk123@gmail.com
#Version: v0.1
#AWS monitor templates
####################
echo "#List s3 buckets"
aws s3 ls

#aws ec2 describe-instances
echo "#List Only Ec2 Instance ID"
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId'
#aws list IAM
#aws iam list-users
echo "#List only ARN from IAM"
aws iam list-users | jq '.Users[].Arn'

# Delete all objects in a bucket
aws s3 rm s3://temp-karthick --recursive

#Create a new s3 bucket
aws s3 mb s3://mybucket-karthick

#Delete empty s3 buckets
aws s3 rb s3://mybucket-karthick --force