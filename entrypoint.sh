echo -e -n "$CONFIG_JSON1"   >  /etc/v2ray/config.json
echo -e -n "$PORT"           >> /etc/v2ray/config.json
echo -e -n "$CONFIG_JSON2"   >> /etc/v2ray/config.json
echo -e -n "$UUID"           >> /etc/v2ray/config.json
echo -e -n "$CONFIG_JSON3"   >> /etc/v2ray/config.json
# /usr/bin/supervisord -c /etc/supervisord.conf && supervisorctl update && supervisorctl restart all
# ./supervisord -c /etc/supervisord.conf && ./supervisorctl status && ./supervisorctl restart v2ray
# ./v2ray -config="/etc/v2ray/config.json"
