#!/bin/bash

WEBSITE=proxy
DATADIR=/var/lib/awstats/$WEBSITE

## merge log
cd /var/log/nginx
gunzip *.gz > /dev/null 2>&1
echo -n > $DATADIR/access.log
for f in $(ls -tr access.log*); do
	cat $f >> $DATADIR/access.log
done
	
## configure
/usr/share/awstats/wwwroot/cgi-bin/awstats.pl \
   -config=$WEBSITE
   
## generate
/usr/share/awstats/tools/awstats_buildstaticpages.pl \
   -config=$WEBSITE \
   -dir=$DATADIR/static 

## host pages
cp /var/lib/awstats/$WEBSITE/static/awstats* /usr/share/nginx/html/awstats/

## update geoip
geoipupdate
