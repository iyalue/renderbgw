#!/bin/bash

web_conf_add(){
	if [ -e /etc/web/config.json ];then
		cat <<EOF >/etc/web/config.json
{
  "inbounds": [
    {
      "port": 10000,
      "listen":"127.0.0.1",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "945be161-8556-4f6f-b373-823270593c26"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
        "path": "/yanghang"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
}
EOF
else
	echo "web"
	exit 1
fi
}

nginx_conf_add(){
	cat << EOF >/etc/nginx/conf.d/default.conf
server {
    listen       80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    location /yanghang/
        {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:10000;
        proxy_http_version 1.1;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$http_host;
    }
}
EOF
}

web_conf_add
nginx_conf_add
web run -config /etc/web/config.json
nginx -g "daemon off;"
