#!/bin/bash

xray_conf_add(){
	if [ -e /etc/xray/config.json ];then
		cat <<EOF >/etc/xray/config.json
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
	echo "请检查v2ray安装"
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

xray_conf_add
nginx_conf_add
xray run -config /etc/xray/config.json
nginx -g "daemon off;"
