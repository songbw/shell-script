#!/bin/sh
cd /tmp
#wget -c http://ftp.jaist.ac.jp/pub/apache/kafka/0.8.2.2/kafka_2.10-0.8.2.2.tgz
scp -P22111 smartadmin@10.105.212.111:/home/smartadmin/kafka_2.10-0.8.2.2.tgz .
#cp -r kafka_2.10-0.8.2.2 /usr/local/server/kafka
sudo tar xvzf kafka_2.10-0.8.2.2.tgz -C /data/server
#cd /usr/local/server/kafka/conf
sudo mkdir -p /data/storm

#修改server.properties
sudo sed -i 's/broker.id=0/broker.id=0/g' /data/server/kafka_2.10-0.8.2.2/config/server.properties
sudo sed -i 's/#host.name=localhost/host.name=c1/g' /data/server/kafka_2.10-0.8.2.2/config/server.properties
sudo sed -i 's/zookeeper.connect=localhost:2181/zookeeper.connect=c1:2181,c2:2181/g' /data/server/kafka_2.10-0.8.2.2/config/server.properties


#启动
#/usr/local/server/kafka/bin/kafka-server-start.sh -daemon /usr/local/server/kafka/config/server.properties

#关闭
#/usr/local/server/kafka/bin/kafka-server-stop.sh

#创建 topic
#/usr/local/server/kafka/bin/kafka-topics.sh --create --topic log --partitions 3 --zookeeper c1:2181/kafka --replication-factor 1

#列出 topic
#/usr/local/server/kafka/bin/kafka-topics.sh --list --zookeeper c1:2181/kafka

#列出 topic 详细信息
#/usr/local/server/kafka/bin/kafka-topics.sh --describe --zookeeper c1:2181/kafka  

#生产数据
#/usr/local/server/kafka/bin/kafka-console-producer.sh --broker-list c1:9092 --topic topic1

#消费数据
#/usr/local/server/kafka/bin/kafka-console-consumer.sh --zookeeper c2:2181 --topic topic1

#删除topic
#登录 zookeeper，删除 /kafka/brokers/topics/topic1 /kafka/config/topics/test1
#删除 kafka 日志目录 /tmp/kafka-logs 下对应的 topic 分区文件