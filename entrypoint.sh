# cd /etc/v2ray
# echo -e -n "$CONFIG_JSON1 \c" > config.json
# echo -e -n "$PORT \c" >> config.json
# echo -e -n "$CONFIG_JSON2 \c" >> config.json
# echo -e -n "$UUID \c" >> config.json
# echo -e -n "$CONFIG_JSON3" >> config.json

#if [ "$CERT_PEM" != "$KEY_PEM" ]; then 
# cd /etc/v2ray \
# echo -e "$CERT_PEM" > cert.pem \
# echo -e "$KEY_PEM"  > key.pem 
#fi

# /usr/bin/supervisord -c /etc/supervisord.conf && supervisorctl update && supervisorctl restart all
# ./supervisord -c /etc/supervisord.conf && ./supervisorctl status && ./supervisorctl restart v2ray
./v2ray -config=/etc/v2ray/config/json
