#!/bin/bash

used=$(/usr/bin/df | grep '/dev/vda1' | awk '{print $5}')

if [ ! '100%' == $used ]; then
	echo "disk is not full yet"
	exit 1
fi

rm -fr /var/log/nginx/access.log-*
rm -fr /var/log/nginx/error.log-*

/root/open-proxy/clear-cache.sh


