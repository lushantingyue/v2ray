FROM alpine:latest

LABEL maintainer "Lushantingyue <lushantingyue@gmail.com>"

# ENV CONFIG_JSON1={\"log\": {\"access\": \"\/var\/log\/v2ray\/access.log\",\"error\": \"\/var\/log\/v2ray\/error.log\",\"loglevel\": \"warning\"},\"inbound\": {\"protocol\": \"vmess\",\"port\":

# ENV CONFIG_JSON2=,\"settings\":{\"clients\":[{\"id\":\" 

# ENV CONFIG_JSON3=\",\"alterId\": 64}]},\"streamSettings\": {\"network\": \"ws\"}},\"inboundDetour\": [],\"outbound\": {\"protocol\": \"freedom\",\"settings\":{} }}

ENV UUID=91cb66ba-a373-43a0-8169-33d4eeaeb857 PORT=8081 CERT_PEM=none KEY_PEM=none VER=3.20

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
RUN apk update && apk add --no-cache --virtual .build-deps ca-certificates curl bash tzdata \
    && cp -r -f /usr/share/zoneinfo/Hongkong /etc/localtime \
    && echo -ne "Alpine Linux 3.4 image. (`uname -rsv`)\n" >> /root/.built \
    && mkdir -m 777 /v2raybin
#ADD resource/v2ray-linux-64.zip /usr/bin/v2ray/v2ray.zip
RUN wget -O /v2raybin/v2ray.zip https://github.com/v2ray/v2ray-core/releases/download/v$VER/v2ray-linux-64.zip

RUN cd /v2raybin && unzip v2ray.zip \
 && mv /v2raybin/v2ray-v$VER-linux-64/v2ray /v2raybin \
 && mv /v2raybin/v2ray-v$VER-linux-64/v2ctl /v2raybin \
 && mv /v2raybin/v2ray-v$VER-linux-64/geoip.dat /v2raybin \
 && mv /v2raybin/v2ray-v$VER-linux-64/geosite.dat /v2raybin \
 && chmod +x /v2raybin/v2ray \
 && rm -rf v2ray.zip \
 && rm -rf v2ray-v$VER-linux-64 \
 && chgrp -R 0 /v2raybin \
 && chmod -R g+rwX /v2raybin

RUN mkdir /etc/v2ray
# COPY config.json /etc/v2ray/config.json

RUN set -ex && \
  apk --no-cache add ca-certificates && \
  mkdir /var/log/v2ray/ && touch /var/log/v2ray/status.log && \
  chmod +x /v2raybin/v2ctl && \
  chmod +x /v2raybin/v2ray

 ENV PATH /v2raybin:$PATH

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

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
# ENTRYPOINT /entrypoint.sh

# CMD [ "/bin/sh" ]
# CMD v2ray -config=/etc/v2ray/config.json
# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
EXPOSE 80

# CMD [ "/usr/bin/supervisord -c /etc/supervisord.conf && /usr/bin/supervisorctl status && /usr/bin/supervisorctl restart v2ray" ]

# RUN cd /etc/v2ray \
#  && echo -e -n "$CONFIG_JSON1"    > config.json \
#  && echo -e -n "$PORT"                  >> config.json \
#  && echo -e -n "$CONFIG_JSON2"  >> config.json \
#  && echo -e -n "$UUID"                  >> config.json \
#  && echo -e -n "$CONFIG_JSON3" >> config.json

CMD /entrypoint.sh

# CMD ["/usr/bin/supervisord -c /etc/supervisord.conf"]
# tail -f "/var/log/v2ray/status.log"
# CMD supervisor -c /etc/supervisord.conf

# CMD /usr/bin/supervisord -c /etc/supervisord.conf && \
#   supervisorctl update && supervisorctl restart all && \
#   supervisorctl status

# dockerfile 运行后就退出？

# 解决办法一：tail -f *.log跟踪监听日志文件
# exec
# docker run -it vm sh -c "/usr/bin/supervisord -c /etc/supervisord.conf && /usr/bin/supervisorctl status && /usr/bin/supervisorctl restart v2ray && tail -f var/log/v2ray/status.log"

# docker run -it vm sh -c "supervisord -c /etc/supervisord.conf && supervisorctl stop all && v2ray -config=/etc/v2ray/config.json && tail -f /var/log/v2ray/status.log"

# docker run -it vm sh -c "supervisord -c /etc/supervisord.conf && supervisorctl restart all && supervisorctl status && tail -f /var/log/v2ray/status.log"

# 解决办法二: docker 守护态运行容器
# docker run -d [images-name]
