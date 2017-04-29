server {
  listen 80;
  listen 443 ssl;
  
  server_name DOMAIN;

  # TLS configuration hardened according to:
  # https://bettercrypto.org/static/applied-crypto-hardening.pdf
  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_ciphers 'EDH+CAMELLIA:EDH+aRSA:EECDH+aRSA+AESGCM:EECDH+aRSA+SHA256:EECDH:+CAMELLIA128:+AES128:+SSLv3:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!DSS:!RC4:!SEED:!IDEA:!ECDSA:kEDH:CAMELLIA128-SHA:AES128-SHA';
  ssl_prefer_server_ciphers on;
  ssl_session_timeout 5m;
  ssl_session_cache shared:SSL:50m;
  ssl_certificate /etc/letsencrypt/live/DOMAIN/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/DOMAIN/privkey.pem;

  add_header Strict-Transport-Security max-age=15768000;

  if ($scheme = http) {
      return 301 https://$host$request_uri;
  }

  location / {
    client_max_body_size 50M;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Frame-Options SAMEORIGIN;
    proxy_pass http://PROXY_HOST:PORT;
  }
}

