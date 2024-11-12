# This script Will Wipe Your MySQL Service , Package and Database. Proceed With Warning
command -v mysql >/dev/null 2>&1 && echo "MySQL Found" || { echo " Hey! MySQL is not installed."; exit 0; }
read -p " !! WARNING: I'm Going to Wipe your MySQL. Do you want to proceed yes/y ? (yes/y): " user_input && \
       	[[ "$user_input" =~ ^(yes|y|Y)$ ]] && echo "Processing the installation..." \
	&& echo "TASK  Started successfully!" || { echo " >>> Exiting script."; exit 0; }

#command -v mysql >/dev/null 2>&1 && echo "MySQL Found" || { echo " Hey! MySQL is not installed."; exit 0; }
sudo systemctl stop mysql
sleep 5
sudo apt remove --purge mysql-server mysql-client mysql-common -y
sudo rm -rf /var/lib/mysql
#sudo rm -rf /etc/mysql
sudo apt autoremove -y  && apt auto-clean -y

[ $? -eq 0 ] && echo "...MySQL Removed!" || echo -e " \n SORRY MySQL Remove - FAILED. Please verify Manually !!!!"
