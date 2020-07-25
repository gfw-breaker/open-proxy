#!/bin/bash

source /etc/profile


# Disk 
used=$(/usr/bin/df | grep '/dev/vda1' | awk '{print $5}')

if [ ! '100%' == $used ]; then
	echo -e "Disk usage : \t$used"
else
	rm -fr /var/log/nginx/access.log-*
	rm -fr /var/log/nginx/error.log-*
	rm -fr /usr/local/nginx/content/cache/*
	rm -fr /usr/share/nginx/cache/*
	service nginx restart
fi


# Memory
mem=$(free -m | grep Mem | awk '{ print $4 }')

if [ "$mem" -gt "50" ]; then
	echo -e "Free memory: \t$mem MB"
else
	echo "Reboot server..."
	init 6
fi

