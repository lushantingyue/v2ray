cd /etc/v2ray/ || echo pwd > err.log
echo -e -n "$CONFIG_JSON1"   >  config.json
echo -e -n "$PORT"           >> config.json
echo -e -n "$CONFIG_JSON2"   >> config.json
echo -e -n "$UUID"           >> config.json
echo -e -n "$CONFIG_JSON3"   >> config.json
# /usr/bin/supervisord -c /etc/supervisord.conf && supervisorctl update && supervisorctl restart all
# ./supervisord -c /etc/supervisord.conf && ./supervisorctl status && ./supervisorctl restart v2ray
# ./v2ray -config="/etc/v2ray/config.json"
./supervisord
./supervisorctl update 
./supervisorctl stop v2ray
./supervisorctl status
./v2ray -config=/etc/v2ray/config.json
