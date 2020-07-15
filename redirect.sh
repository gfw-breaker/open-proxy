#!/bin/bash

target=$1

for f in $(ls /etc/nginx/conf.d/*.conf); do
	sed -i "s/redirect_ip/$targe/g" $f
	sed -i "s/#rewrite/rewrite/g" $f
done

service nginx restart


