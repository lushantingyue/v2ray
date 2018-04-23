apk add supervisor \
 && touch /etc/supervisor/conf.d/v2ray-caddy.conf \
 && cd    /etc/supervisor/conf.d \
 && echo -e -n "$SUPERVISOR_CONF" > v2ray-caddy.conf \
 && supervisorctl update all \
 && supervisorctl restart v2ray \
 && supervisorctl start caddy
