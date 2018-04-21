apt-get install supervisor -y \
 && touch /etc/supervisor/conf.d/v2ray.conf \
 && vi /etc/supervisor/conf.d/v2ray.conf \
 && echo -e -n "$V2RAY_CONF" > v2ray.conf \
 && touch /etc/supervisor/conf.d/caddy.conf \
 && vi /etc/supervisor/conf.d/caddy.conf \
 && echo -e -n "$SUPERVISOR_CONF" > caddy.conf \
 && supervisorctl update all \
 && supervisorctl start v2ray \
 && supervisorctl start caddy