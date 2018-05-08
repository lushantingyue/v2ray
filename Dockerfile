FROM alpine:latest

LABEL maintainer "Lushantingyue <lushantingyue@gmail.com>"

ENV CONFIG_JSON1=none CONFIG_JSON2=none CONFIG_JSON3=none UUID=91cb66ba-a373-43a0-8169-33d4eeaeb857 PORT=8081 CERT_PEM=none KEY_PEM=none VER=3.20

ADD entrypoint.sh /entrypoint.sh 
RUN chmod +x /entrypoint.sh 

# 官方配置 v2ray-core
# ADD https://storage.googleapis.com/v2ray-docker/v2ray /usr/bin/v2ray/
# ADD https://storage.googleapis.com/v2ray-docker/v2ctl /usr/bin/v2ray/
# ADD https://storage.googleapis.com/v2ray-docker/geoip.dat /usr/bin/v2ray/
# ADD https://storage.googleapis.com/v2ray-docker/geosite.dat /usr/bin/v2ray/

# COPY config.json /etc/v2ray/config.json

# RUN set -ex && \
#     apk --no-cache add ca-certificates && \
#     mkdir /var/log/v2ray/ &&\
#     chmod +x /usr/bin/v2ray/v2ctl && \
#     chmod +x /usr/bin/v2ray/v2ray

# ENV PATH /usr/bin/v2ray:$PATH

# 配置 v2ray-core
RUN apk add --no-cache --virtual .build-deps ca-certificates curl && mkdir -m 777 /usr/bin/v2ray
#ADD resource/v2ray-linux-64.zip /usr/bin/v2ray/v2ray.zip
RUN wget -O /usr/bin/v2ray/v2ray.zip https://github.com/v2ray/v2ray-core/releases/download/v$VER/v2ray-linux-64.zip

RUN mkdir /etc/v2ray && touch /etc/v2ray/config.json

RUN /entrypoint.sh

RUN cd /usr/bin/v2ray && unzip v2ray.zip \
 && mv /usr/bin/v2ray/v2ray-v$VER-linux-64/v2ray /usr/bin/v2ray \
 && mv /usr/bin/v2ray/v2ray-v$VER-linux-64/v2ctl /usr/bin/v2ray \
 && mv /usr/bin/v2ray/v2ray-v$VER-linux-64/geoip.dat /usr/bin/v2ray \
 && mv /usr/bin/v2ray/v2ray-v$VER-linux-64/geosite.dat /usr/bin/v2ray \
 && chmod +x /usr/bin/v2ray/v2ray \
 && rm -rf v2ray.zip \
 && rm -rf v2ray-v$VER-linux-64 \
 && chgrp -R 0 /usr/bin/v2ray \
 && chmod -R g+rwX /usr/bin/v2ray

RUN set -ex && \
  apk --no-cache add ca-certificates && \
  mkdir /var/log/v2ray/ &&\
  chmod +x /usr/bin/v2ray/v2ctl && \
  chmod +x /usr/bin/v2ray/v2ray

 ENV PATH /usr/bin/v2ray:$PATH

# 配置 Caddy-Server
RUN mkdir /etc/caddy
ADD resource/caddy_v0.10.14_linux_amd64.zip /etc/caddy/caddy_v0.10.14_linux_amd64.zip
RUN cd /etc/caddy \
 && unzip caddy_v0.10.14_linux_amd64.zip && mv caddy_v0.10.14_linux_amd64/* /etc/caddy \
 && rm -rf caddy_v0.10.14_linux_amd64.zip \
 && chmod +x /etc/caddy/caddy \
 && touch /etc/caddy/caddy.conf \
 && echo -e -n "$DOMAIN" > /etc/caddy/caddy.conf

# 配置 Supervisor
RUN apk update \
 && apk add supervisor
# 配置V2Ray/Caddy守护进程
COPY supervisord.conf /etc/supervisord.conf

ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf && supervisorctl update && supervisorctl restart all