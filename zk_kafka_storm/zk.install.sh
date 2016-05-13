#!/bin/sh
cd /tmp
#mkdir -p download && cd download
#wget -c http://www.eu.apache.org/dist/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
scp -P22111 smartadmin@10.105.212.111:/home/smartadmin/zookeeper-3.4.6.tar.gz .
sudo mkdir -p /data/server
sudo tar xvzf zookeeper-3.4.6.tar.gz -C /data/server
#cp -r zookeeper-3.4.6 /usr/local/server/zookeeper

#cd /usr/local/server/zookeeper/conf
#touch zoo.cfg

#修改配置文件  zoo.cfg

sudo bash -c "cat > /data/server/zookeeper-3.4.6/conf/zoo.cfg << EOF
tickTime=2000
dataDir=/data/zookeeper
clientPort=2181
initLimit=5
syncLimit=2
server.1=c1:2888:3888
server.2=c2:2888:3888
#server.3=c3:2888:3888
EOF"


#打开 /etc/hosts
sudo bash -c "cat >> /etc/hosts << EOF
10.105.235.146 c1
10.105.234.62 c2
EOF"

#192.168.33.22 c3


#创建数据目录
sudo mkdir -p /data/zookeeper


#创建myid文件， id 与 zoo.cfg 中的序号对应
sudo bash -c "echo 1 > /data/zookeeper/my.id"

#常用命令
#启动
#/usr/local/server/zookeeper/bin/zkServer.sh start 
#重启
#/usr/local/server/zookeeper/bin/zkServer.sh restart
#关闭
#/usr/local/server/zookeeper/bin/zkServer.sh stop
#在其中一台用客户端连接
#/usr/local/server/zookeeper/bin/zkCli.sh -server c1:2181
#查看状态
#/usr/local/server/zookeeper/bin/zkServer.sh status
#