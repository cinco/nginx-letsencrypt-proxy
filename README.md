# nginx-letsencrypt-proxy

_Docker container for NGINX proxy for multiple domains with Let's Encrypt_

There are quite a few NGINX/Let's Encrypt options around. I could not find one that fitted my
needs, so here is yet another NGINX/Let's Encrypt proxy solution.

## Use Case

Several web servers are running as docker images on the same host. Each should have its own domain name with a valid TLS certificate.

## Solution

1. Each web service is exposed on a different port on the host
1. Let's Encrypt is run to create a new TLS certificate for each domain name
1. NGINX listens for incoming requests and proxies these to the various exposed ports, based on the incoming request domain name. It uses the TLS certificates for HTTPS

## In Detail

This docker image contains NGINX, Let's Encrypt, and a script to run Let's Encrypt, then create
the NGINX virtual host configuration files, then run NGINX.

## To Use (With Docker Compose)

See example [Docker Compose](docker-compose.yml) file, which uses these variables from .env:

#### CERT_EMAIL

Set ```CERT_EMAIL``` to the email address you'd like for Let's Encrypt's expiration emails.

#### CERT_TEST

If, like me, you end up testing things more times than you think, you may well fall foul of Let's Encrypt's rate limiting.

Set ```CERT_TEST=true``` to create test certificates only, and avoid such issues until you're certain.

__Note that you'll have to remove old certificates if you switch from test to live. This can be achieved by removing the certificates docker volume, if you have one.__

#### DOMAINS

This is a list of domains for both certificates, and for the proxy. The format is:

```DOMAINS=PORT1:DOMAIN1 PORT2:DOMAIN2 PORT3:DOMAIN3 ...```

#### PROXY_HOST

This is the address to proxy all requests to. For docker, I usually use ```172.17.0.1``` to
reference the host machine (where it can find the exposed ports). e.g. ```PROXY_HOST=172.17.0.1```.

### Example Settings

My .env file looks something like this:

```
CERT_EMAIL=doug@my_email_address_domain.com
CERT_TEST=false
DOMAINS=8001:site1.zenly.xyz 8002:site2.zenly.xyz 8003:site3.zenly.xyz
PROXY_HOST=172.17.0.1
```

### Volumes

As per the example [Docker Compose](docker-compose.yml) file, you'll want to have /etc/letsencrypt as a volume, otherwise
Let's Encrypt will need to re-create the certificates each time.

## TO DO

Auto update expired certificates. Currently relying on restarting the container

