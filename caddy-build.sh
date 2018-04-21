mkdir /etc/caddy \
 && wget https://github.com/mholt/caddy/releases/download/v0.10.11/caddy_v0.10.11_linux_386.tar.gz \
 && tar -zxvf caddy_v0.10.11_linux_386.tar.gz -C /etc/caddy/caddy \
 && chmod +x /etc/caddy/caddy \
 && touch /etc/caddy/caddy.conf \
 && vi /etc/caddy/caddy.conf \
 && echo -e -n "$DOMAIN" > /etc/caddy/caddy.conf
 