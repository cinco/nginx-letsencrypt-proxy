#!/bin/sh
#
#   Copyright 2017 Douglas Gibbons
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
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
