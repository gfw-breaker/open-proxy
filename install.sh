#!/bin/bash
# auth : gfw-breaker

rpm -ihv http://installrepo.kaltura.org/releases/kaltura-release.noarch.rpm
yum install -y kaltura-nginx-1.16.0-2

rm -fr /etc/nginx/conf.d/*

mkdir -p /usr/share/nginx/cache
mkdir -p /usr/share/nginx/html

source config

server_ip=$(/sbin/ifconfig eth0 | grep "inet addr" | sed -n 1p | cut -d':' -f2 | cut -d' ' -f1)

if [ -z $server_ip ]; then
	server_ip=$(/sbin/ifconfig eth0 | grep "broadcast" | awk '{print $2}')
fi

if [ -z $data_server_ip ]; then
	data_server_ip=$server_ip
fi

cp common/* /etc/nginx/
cp sites/* /etc/nginx/conf.d
cp pages/* /usr/share/nginx/html

for f in $(ls /etc/nginx/conf.d/*.conf); do
	sed -i "s/local_server_ip/$server_ip/g" $f
	sed -i "s/data_server_ip/$data_server_ip/g" $f
done

for f in $(ls /usr/share/nginx/html/*.html); do
	sed -i "s/local_server_ip/$server_ip/g" $f
	sed -i "s/data_server_ip/$data_server_ip/g" $f
done

#page=/usr/share/nginx/html/index.html
#sed -i "s#http.*m3u8#http://$data_server_ip:8009/cn/live800/playlist.m3u8#" $page

# CentOS6
mv /etc/init.d/kaltura-nginx /etc/init.d/nginx
chkconfig nginx on

# CentOS7
mv /usr/lib/systemd/system/kaltura-nginx.service /usr/lib/systemd/system/nginx.service
systemctl enable nginx

service nginx restart

