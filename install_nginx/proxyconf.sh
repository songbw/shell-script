#!/bin/sh
if [ $1 == "--help" ] ; then
		echo "USAGE:$0 域名 代理端口号"
		exit 0
fi
if [ $# != 2 ];then
     echo "参数数量不对！"
     echo "USAGE:$0 域名 代理端口号"
     exit 1
fi
read -p "输入反向代理的IP:  " IP_ADD
cat > $1.conf <<EOF
upstream $1.haotiben.cn {
                 server $IP_ADD:$2;
             } 
 server
    {
    listen 80;
    server_name $1.haotiben.cn;

    location / {
    proxy_pass http://$1.haotiben.cn;
    proxy_redirect off;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
    } 
EOF
