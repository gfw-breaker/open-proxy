#!/bin/bash

WEBSITE=proxy
DATADIR=/var/lib/awstats/$WEBSITE
log=$DATADIR/access.log


## merge log
cd /var/log/nginx
gunzip *.gz > /dev/null 2>&1
echo -n > $log
for f in $(ls -tr access.log*); do
	cat $f >> $log
done

goaccess $log --log-format=COMBINED -q --ignore-crawlers -a -o /usr/share/nginx/html/report.html


