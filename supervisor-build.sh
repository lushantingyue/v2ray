apk add supervisor \
 && mkdir /etc/supervisor/conf.d \
 && cd    /etc/supervisor/conf.d \
 ## V2Ray守护进程配置
 && touch /etc/supervisor/conf.d/v2ray.conf \
 && echo -e -n "$V2RAY_CONF" > v2ray.conf \
 ## Caddy守护进程配置
 && touch /etc/supervisor/conf.d/caddy.conf \
 && echo -e -n "$CADDY_CONF" > caddy.conf \
 && supervisord -c /etc/supervisor/conf.d/v2ray.conf \
 && supervisord -c /etc/supervisor/conf.d/caddy.conf \
 && supervisorctl update all \
 && supervisorctl restart v2ray \
 && supervisorctl start caddy
