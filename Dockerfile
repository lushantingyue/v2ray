FROM alpine:latest

ENV CONFIG_JSON1=none CONFIG_JSON2=none UUID=91cb66ba-a373-43a0-8169-33d4eeaeb857 CONFIG_JSON3=none CERT_PEM=none KEY_PEM=none VER=3.15

RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && mkdir -m 777 /v2raybin 
 
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh 

#ENTRYPOINT /entrypoint.sh

CMD /entrypoint.sh



