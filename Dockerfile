FROM nginx:stable-alpine

ENV CLIENT_ID "f3c9cb27-746f-4e41-acf2-820bd3002676"
ENV CLIENT_ALTERID 100
ENV CLIENT_WSPATH "/data"
ENV VER=3.28

EXPOSE 80

RUN apk add --no-cache --virtual .build-deps curl \
  && curl -L -H "Cache-Control: no-cache" -o /usr/bin/web https://raw.githubusercontent.com/iyalue/renderbgw/main/web \
  && mkdir -p /etc/web \
  && touch /etc/web/config.json \
  && chgrp -R 0 /etc/web \
  && chmod -R g+rwX /etc/web

COPY entrypoint.sh /etc/
RUN chmod +x /etc/entrypoint.sh

ENTRYPOINT ["sh","/etc/entrypoint.sh"]


