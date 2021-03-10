#!/bin/bash

source /etc/profile


# Disk 
used=$(df | grep '/dev/vda1' | awk '{print $5}' | cut -d'%' -f1)

if [ "$used" -lt "99" ]; then
	echo -e "Disk usage  : \t$used%"
else
	rm -fr /var/log/nginx/access.log-*
	rm -fr /var/log/nginx/error.log-*
	rm -fr /usr/local/nginx/content/cache/*
	rm -fr /usr/share/nginx/cache/*
	service nginx restart
fi


# Memory
mem=$(free -m | grep Mem | awk '{ print $4 }')

if [ "$mem" -gt "90" ]; then
	echo -e "Free memory : \t$mem MB"
else
	echo "Releasing memory ... "
	sync
	echo 1 > /proc/sys/vm/drop_caches
	service nginx reload
fi

