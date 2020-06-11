#!/bin/bash
# auth : gfw-breaker

rpm -ihv http://installrepo.kaltura.org/releases/kaltura-release.noarch.rpm
yum install -y kaltura-nginx-1.16.0-2

rm -fr /etc/nginx/conf.d/*

mkdir -p /usr/local/nginx/content/cache
mkdir -p /usr/share/nginx/html

server_ip=$(ifconfig | grep "inet" | sed -n 1p | cut -d':' -f2 | cut -d' ' -f1)

for f in $(ls sites/*.conf); do
	sed -i "s/local_server_ip/$server_ip/g" $f
done

for f in $(ls pages/*.html); do
	sed -i "s/local_server_ip/$server_ip/g" $f
done

cp common/* /etc/nginx/
cp sites/* /etc/nginx/conf.d
cp pages/* /usr/share/nginx/html

mv /etc/init.d/kaltura-nginx /etc/init.d/nginx

chkconfig nginx on
service nginx restart

