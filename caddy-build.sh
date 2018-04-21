mkdir /etc/caddy \
 && wget https://github.com/mholt/caddy/releases/download/v0.10.14/caddy_v0.10.14_linux_386.tar.gz \
 && tar -zxvf caddy_v0.10.14_linux_386.tar.gz -C /etc/caddy/caddy \
 && rm -rf caddy_v0.10.14_linux_38 6.tar.gz \
 && chmod +x /etc/caddy/caddy \
 && touch /etc/caddy/caddy.conf \
 && vi /etc/caddy/caddy.conf \
 && echo -e -n "$DOMAIN" > /etc/caddy/caddy.conf
