#!/bin/sh
curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.2.6.tgz

sudo tar xzf mongodb-linux-x86_64-3.2.6.tgz -C /usr/local/

sudo ln -s /usr/local/mongodb-linux-x86_64-3.2.6/ /usr/local/mongodb

sudo bash -c "cat >> /etc/profile << EOF
export MONGODB_HOME=/usr/local/mongodb
export PATH=$MONGODB_HOME/bin:$PATH
EOF"

sudo bash -c 'source /etc/profile'

sudo mkdir -p /usr/local/mongodb/data

sudo mkdir -p /usr/local/mongodb/log

sudo mkdir -p /usr/local/mongodb/conf

sudo bash -c "cat > /usr/local/mongodb/conf/mongodb.conf << EOF
#bind_ip=0.0.0.0
port=27017
dbpath=/usr/local/mongodb/data
logpath=/usr/local/mongodb/log/mongodb.log
pidfilepath=/usr/local/mongodb/log/mongodb.pid
directoryperdb=true
logappend=true
oplogSize=1000
fork=true
#noprealloc=true
master=true
EOF"

sudo useradd mongodb -M -s /sbin/nologin

sudo chown -R mongodb.mongodb /usr/local/mongodb-linux-x86_64-3.2.6
#启动（root权限启动）
mongod -f /usr/local/mongodb/conf/mongodb.conf

#安装目录/usr/local/mongodb/