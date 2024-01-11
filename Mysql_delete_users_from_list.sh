#Delete MySQL or MariaDB from user_files by using BASH script
###############################################################
# Requirements: Please save the db users on user_list in current dir 
ADMIN_USER='root'   # Username Here
ADMIN_PASS=''      # Password here 
HOST='localhost'   # Hostname here

# Save the DB User list into file 
mysql -h$HOST -u$ADMIN_USER -p"{$ADMIN_PASS}" -e " SELECT user,host FROM mysql. user;" > current_user_list

for user in `cat user_list`    
do
       mysql -h$HOST -u$ADMIN_USER -p"{$ADMIN_PASS}" -e " drop user '$user'@'localhost';"  >  /dev/null 2>&
 if [ $? == 0 ]; then
       echo "user deleted on localhost user: $user"
 else 
       mysql -h$HOST -u$ADMIN_USER -p"{$ADMIN_PASS}" -e " drop user '$user'@'%';"  >  /dev/null 2>&1
fi
if [ $? == 0 ]; then
      echo "user deleted from % user: $user"
 else
      echo "user not found on MYSQL: $user"
fi
done
