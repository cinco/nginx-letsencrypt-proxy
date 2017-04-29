FROM nginx:alpine

RUN apk add --update nginx-lua certbot letsencrypt m4 && rm -rf /var/cache/apk/*

COPY domain.conf.m4 /etc/nginx/domain.conf.m4

WORKDIR /
COPY entrypoint.sh .
RUN chmod +rx entrypoint.sh

ENTRYPOINT ["/bin/sh", "/entrypoint.sh" ]

