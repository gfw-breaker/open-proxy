#!/bin/bash

WEBSITE=proxy
DATADIR=/var/lib/awstats/$WEBSITE
NGINX=/usr/share/nginx/html

# install 
yum install -y awstats htmldoc geoip-geolite perl-Geo-IP perl-CPAN

echo yes | perl -MCPAN -e "install Geo::IP::PurePerl"
perl -MCPAN -e "install Geo::IP"

[ ! -d $DATADIR/static ] && \
    mkdir -p $DATADIR/static
ln -snf /usr/share/awstats/wwwroot/icon \
   $DATADIR/static/icon
ln -snf /usr/share/awstats/wwwroot/cgi-bin \
   $DATADIR/static/cgi-bin
 
sed -e "s|localhost\.localdomain|$WEBSITE|g" \
   /etc/awstats/awstats.model.conf > \
      /etc/awstats/awstats.$WEBSITE.conf

sed -i -e "s|^\(LogFile\)=.*$|\1=\"$DATADIR/access.log\"|g" \
   /etc/awstats/awstats.$WEBSITE.conf
 
# Disable DNS (for speed mostly)
sed -i -e "s|^\(DNSLookup\)=.*$|\1=0|g" \
   /etc/awstats/awstats.$WEBSITE.conf
 
# For PDF Generation we need to update the relative
# paths for the icons.
sed -i -e "s|^\(DirIcons\)=.*$|\1=\"icon\"|g" \
   /etc/awstats/awstats.$WEBSITE.conf
sed -i -e "s|^\(DirCgi\)=.*$|\1=\"cgi-bin\"|g" \
   /etc/awstats/awstats.$WEBSITE.conf


sed -i -e '/^LoadPlugin=.*/d' /etc/awstats/awstats.$WEBSITE.conf
cat << _EOF >> /etc/awstats/awstats.$WEBSITE.conf
#LoadPlugin="geoip GEOIP_STANDARD /usr/share/GeoIP/GeoIP.dat"
#LoadPlugin="geoip_city_maxmind GEOIP_STANDARD /usr/share/GeoIP/GeoIPCity.dat" 
_EOF

sed -i -e "s|^\(LogFormat\)=.*$|\1=\"%host %other %logname %time1 %methodurl %code %bytesd %refererquot %uaquot\"|g" \
   /etc/awstats/awstats.$WEBSITE.conf

mkdir -p $NGINX/awstats
cp -r /usr/share/awstats/wwwroot/* $NGINX/awstats

cat > $NGINX/awstats/index.html << EOF
<META http-equiv="Refresh" content="0; url=awstats.proxy.html">
EOF


