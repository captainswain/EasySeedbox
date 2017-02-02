#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install your seed box"
    exit 1
fi

clear

echo "
____ ____ ____ _   _    ____ ____ ____ ___  ___  ____ _  _
|___ |__| [__   \_/     [__  |___ |___ |  \ |__] |  |  \/
|___ |  | ___]   |      ___] |___ |___ |__/ |__] |__| _/\_ "

echo "========================================================================="
echo "Easy Seedbox installer - Transmission"
echo "========================================================================="
echo "Description:"
echo " Installs Transmission and WebUI to create a simple seedbox on any"
echo " Ubuntu or Debian VPS."
echo "Script written by swain. - swain.pw"
echo "========================================================================="


#--------------------------
# Good Vars
#--------------------------

# Try and find ip, if not available pull from network.
if [ "$IP" = "" ]; then
        IP=$(wget -qO- ipv4.icanhazip.com)
fi


#Set settings file config.
SETTINGSFILE="/etc/transmission-daemon/settings.json"


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
        username="pass"
    fi
    echo "==========================="
    echo " Password = $pass"
    echo "==========================="


echo "============================Starting Install=================================="
apt-get -y  update
apt-get -y install transmission-daemon curl

echo "============================making directories================================"
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
echo "============================Permissions======================================="
usermod -a -G debian-transmission root
chgrp -R debian-transmission /home/downloads
chmod -R 770 /home/downloads
cd $cur_dir
echo "============================Updating Config==================================="

# rm -f /etc/transmission-daemon/settings.json
truncate -s0 $SETTINGSFILE

cat > $SETTINGSFILE <<- EOM
{
"alt-speed-down": 50,

"alt-speed-enabled": false,

"alt-speed-time-begin": 540,

"alt-speed-time-day": 127,

"alt-speed-time-enabled": false,

"alt-speed-time-end": 1020,

"alt-speed-up": 50,

"bind-address-ipv4": "0.0.0.0",

"bind-address-ipv6": "::",

"blocklist-enabled": false,

"dht-enabled": true,

"download-dir": "/home/downloads/downloaded/",

"incomplete-dir": "/home/downloads/incomplete/",

"incomplete-dir-enabled": true,

"watch-dir": "/home/downloads/watch/",

"watch-dir-enabled": true,

"download-limit": 100,

"download-limit-enabled": 0,

"encryption": 2,

"lazy-bitfield-enabled": true,

"lpd-enabled": false,

"max-peers-global": 200,

"message-level": 2,

"open-file-limit": 32,

"peer-limit-global": 240,

"peer-limit-per-torrent": 60,

"peer-port": 20628,

"peer-port-random-high": 20500,

"peer-port-random-low": 20599,

"peer-port-random-on-start": true,

"peer-socket-tos": 0,

"pex-enabled": true,

"port-forwarding-enabled": false,

"preallocation": 1,

"proxy": "",

"proxy-auth-enabled": false,

"proxy-auth-password": "",

"proxy-auth-username": "",

"proxy-enabled": false,

"proxy-port": 80,

"proxy-type": 0,

"ratio-limit": 0.2500,

"ratio-limit-enabled": true,

"rename-partial-files": true,

"rpc-authentication-required": true,

"rpc-bind-address": "0.0.0.0",

"rpc-enabled": true,

"rpc-username": "uzr",

"rpc-password": "pzw",

"rpc-port": 9091,

"rpc-whitelist": "127.0.0.1,*.*.*.*",

"rpc-whitelist-enabled": true,

"script-torrent-done-enabled": false,

"script-torrent-done-filename": "",

"speed-limit-down": 100,

"speed-limit-down-enabled": false,

"speed-limit-up": 1,

"speed-limit-up-enabled": true,

"start-added-torrents": true,

"trash-original-torrent-files": false,

"umask": 2,

"upload-limit": 100,

"upload-limit-enabled": 0,

"upload-slots-per-torrent": 1

}
EOM


sed -i 's/uzr/'$username'/g' /etc/transmission-daemon/settings.json
sed -i 's/pzw/'$pass'/g' /etc/transmission-daemon/settings.json
echo "============================Restarting Transmission==========================="
service transmission-daemon reload
clear
echo "========================================================================="
echo "                   Seedbox Installed successfully! "
echo "========================================================================="
echo " WebUI URL: http://$IP:9091"
echo " WebUI Username: $username"
echo " WebUI Password: $pass"
echo " Download Location: /home/downloads"
echo ""
echo "========================================================================="
echo "                            Script by swain.pw                           "
echo "========================================================================="
