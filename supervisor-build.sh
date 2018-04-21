apt-get install supervisor -y \
 && touch /etc/supervisor/conf.d/v2ray-caddy.conf \
 && vi /etc/supervisor/conf.d/v2ray-caddy.conf \
 && echo -e -n "$SUPERVISOR_CONF" > v2ray-caddy.conf \
 && supervisorctl update all \
 && supervisorctl start v2ray \
 && supervisorctl start caddy
