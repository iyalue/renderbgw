FROM nginx:stable-alpine

ENV CLIENT_ID "f3c9cb27-746f-4e41-acf2-820bd3002676"
ENV CLIENT_ALTERID 100
ENV CLIENT_WSPATH "/data"
ENV VER=3.28

EXPOSE 80

RUN apk add --no-cache --virtual .build-deps curl \
  && curl -L -H "Cache-Control: no-cache" -o /xray.zip https://github.com/XTLS/Xray-core/releases/download/v1.7.5/Xray-linux-64.zip \
  && mkdir /usr/bin/xray /etc/xray \
  && touch /etc/xray/config.json \
  && unzip /xray.zip -d /usr/bin/xray \
  && rm -rf /xray.zip \
  && chgrp -R 0 /etc/xray \
  && chmod -R g+rwX /etc/xray

COPY entrypoint.sh /etc/
RUN chmod +x /etc/entrypoint.sh

ENTRYPOINT ["sh","/etc/entrypoint.sh"]


