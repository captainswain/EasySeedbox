#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install your seed box"
    exit 1
fi

clear
echo "========================================================================="
echo "Easy Seedbox installer - Transmission"
echo "========================================================================="
echo "Description:"
echo " Installs seed box for you. Transmission"
echo "Script written by swain. - swain.pw"
echo "========================================================================="
cur_dir=$(pwd)


    accepted="N"
    echo "Do you want to install the seed box?:"
    read -p "(Y/N):" accepted
    if [ "$accepted" = "N" ]; then
        exit
    fi
    if [ "$accepted" = "n" ]; then
        exit
    fi
echo "============================WebUI Info=================================="
    username="user"
    echo "Please input your requested WebUI username for the seedbox:"
    read -p "(Default user:user):" username
    if [ "$username" = "" ]; then
        username="user"
    fi
    echo "==========================="
    echo " Username = $username"
    echo "==========================="
    pass="pass"
    echo "Please input your requested WebUI password for the seedbox:"
    read -p "(Default Password:pass):" pass
    if [ "$pass" = "" ]; then
        username="passr"
    fi
    echo "==========================="
    echo " Password = $pass"
    echo "==========================="


echo "============================Starting Install=================================="
IP=`curl -s http://swain.pw/scripts/ip.php`
apt-get -y  update
apt-get -y install transmission-daemon curl

echo "============================making directorys=================================="
if [ ! -d "/home/downloads" ]; then
    mkdir /home/downloads
echo "/home/downloads  [created]"
else
echo "/home/downloads [found]"
fi
# 2nd if
if [ ! -d "/home/downloads/watch" ]; then
  mkdir /home/downloads/watch
echo "/home/downloads/watch [created]"
else
echo "/home/downloads/watch [found]"

#3rd if
fi
if [ ! -d "/home/downloads/incomplete" ]; then
   mkdir /home/downloads/incomplete
echo "/home/downloads/incomplete [created]"

else
echo "/home/downloads/incomplete [found]"
fi
if [ ! -d "/home/downloads/downloaded" ]; then
  mkdir /home/downloads/downloaded
echo "/home/downloads/downloaded [created]"
else
echo "/home/downloads/downloaded [found]"
fi
echo "============================Permissions=================================="
usermod -a -G debian-transmission root
chgrp -R debian-transmission /home/downloads
chmod -R 770 /home/downloads
echo "============================Downloading Config============================"
if [ -s seedboxconfig.txt ]; then
  echo " Seedbox config [found]"
  else
  echo "Downloading Seedbox Config......"
  wget -c http://dl.dropbox.com/u/22145210/seedboxconfig.txt
fi

cd $cur_dir
echo "============================Updating Config============================"

rm -f /etc/transmission-daemon/settings.json
mv -i seedboxconfig.txt /etc/transmission-daemon/settings.json
sed -i 's/user/'$username'/g' /etc/transmission-daemon/settings.json
sed -i 's/password/'$pass'/g' /etc/transmission-daemon/settings.json
echo "============================Restarting Transmission====================="

service transmission-daemon reload
echo "Install Complete!"
echo "========================================================================="
echo "                   Seedbox Installed successfully! "
echo "========================================================================="
IP=`http://swain.pw/scripts/ip.php`
echo " WebUI URL: http://$IP:9091"
echo " WebUI Username: $username"
echo " WebUI Password: $pass"
echo " Download Location: /home/downloads"
echo ""
echo "========================================================================="
echo "                            Script by swain.pw                           "
echo "========================================================================="
