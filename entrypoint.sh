#!/bin/sh
set -e

options=""

if [ "$CERT_TEST" == true ]
then
  echo "Building test certificates"
  options="$options --test-cert"
else
  echo "Building real certificates"
fi

for RECORD in $DOMAINS
do
  PORT=${RECORD%%:*}
  DOMAIN=${RECORD#*:}
  echo "domain $DOMAIN"
  certbot certonly --standalone -d $DOMAIN -m $CERT_EMAIL -n --agree-tos $options
  m4 \
    -DPROXY_HOST=$PROXY_HOST \
    -DDOMAIN=$DOMAIN \
    -DPORT=$PORT \
    /etc/nginx/domain.conf.m4 > /etc/nginx/conf.d/${DOMAIN}.conf
done

# Run nginx
echo "Running NGINX"
nginx -g 'daemon off;'
