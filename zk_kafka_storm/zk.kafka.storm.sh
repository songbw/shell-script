#参考：http://www.dahouduan.com/2016/02/24/Tutorial-zookeeper-kafka-storm-cluster/
#zookeeper
cd ~
mkdir -p download && cd download
wget -c http://www.eu.apache.org/dist/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz

tar xvzf zookeeper-3.4.6.tar.gz
mkdir -p /usr/local/server
cp -r zookeeper-3.4.6 /usr/local/server/zookeeper

cd /usr/local/server/zookeeper/conf
touch zoo.cfg

#修改配置文件  zoo.cfg

sudo bash -c "cat > /home/smartadmin/zookeeper-3.4.6/conf/zoo.cfg << EOF
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
192.168.33.20 c1
192.168.33.21 c2
192.168.33.22 c3


#创建数据目录
mkdir -p /data/zookeeper


#创建myid文件， id 与 zoo.cfg 中的序号对应
echo 1 > /data/zookeeper/my.id

#常用命令
#启动
/usr/local/server/zookeeper/bin/zkServer.sh start 
#重启
/usr/local/server/zookeeper/bin/zkServer.sh restart
#关闭
/usr/local/server/zookeeper/bin/zkServer.sh stop
#在其中一台用客户端连接
/usr/local/server/zookeeper/bin/zkCli.sh -server c1:2181
#查看状态
/usr/local/server/zookeeper/bin/zkServer.sh status
#

#kafka
cd ~
wget -c http://ftp.jaist.ac.jp/pub/apache/kafka/0.8.2.2/kafka_2.10-0.8.2.2.tgz
cp -r kafka_2.10-0.8.2.2 /usr/local/server/kafka

cd /usr/local/server/kafka/conf
mkdir -p /data/storm

#修改server.properties
sed -i 's/broker.id=0/broker.id=0/g' /home/smartadmin/kafka_2.10-0.8.2.2/config/server.properties
sed -i 's/#host.name=localhost/host.name=c1/g' /home/smartadmin/kafka_2.10-0.8.2.2/config/server.properties
sed -i 's/zookeeper.connect=localhost:2181/zookeeper.connect=c1:2181,c2:2181/g' /home/smartadmin/kafka_2.10-0.8.2.2/config/server.properties


#启动
/usr/local/server/kafka/bin/kafka-server-start.sh -daemon /usr/local/server/kafka/config/server.properties

#关闭
/usr/local/server/kafka/bin/kafka-server-stop.sh

#创建 topic
/usr/local/server/kafka/bin/kafka-topics.sh --create --topic log --partitions 3 --zookeeper c1:2181/kafka --replication-factor 1

#列出 topic
/usr/local/server/kafka/bin/kafka-topics.sh --list --zookeeper c1:2181/kafka

#列出 topic 详细信息
/usr/local/server/kafka/bin/kafka-topics.sh --describe --zookeeper c1:2181/kafka  

#生产数据
/usr/local/server/kafka/bin/kafka-console-producer.sh --broker-list c1:9092 --topic topic1

#消费数据
/usr/local/server/kafka/bin/kafka-console-consumer.sh --zookeeper c2:2181 --topic topic1

#删除topic
#登录 zookeeper，删除 /kafka/brokers/topics/topic1 /kafka/config/topics/test1
#删除 kafka 日志目录 /tmp/kafka-logs 下对应的 topic 分区文件


#storm
wget -c http://ftp.jaist.ac.jp/pub/apache/storm/apache-storm-0.9.6/apache-storm-0.9.6.tar.gz
tar xvzf apache-storm-0.9.6.tar.gz

cp -r apache-storm-0.9.6 /usr/local/server/storm
cd /usr/local/server/storm/conf

mkdir -p /data/storm


#打开 storm.yaml 修改 storm.zookeeper.servers 为

#sed -i 's/# storm.zookeeper.servers:/storm.zookeeper.servers:/g' /home/smartadmin/apache-storm-0.9.6/conf/storm.yaml
#sed -i 's/#     - "server1"/    - "c1"/g' /home/smartadmin/apache-storm-0.9.6/conf/storm.yaml
#sed -i 's/#     - "server2"/    - "c2"/g' /home/smartadmin/apache-storm-0.9.6/conf/storm.yaml
#sed -i 's/# nimbus.host: "nimbus"/nimbus.host: "c1"/g' /home/smartadmin/apache-storm-0.9.6/conf/storm.yaml
echo 'storm.zookeeper.servers:'>>/home/smartadmin/apache-storm-0.9.6/conf/storm.yaml
echo '    - "c1"'>>/home/smartadmin/apache-storm-0.9.6/conf/storm.yaml
echo '    - "c2"'>>/home/smartadmin/apache-storm-0.9.6/conf/storm.yaml
echo 'nimbus.host: "c1"'>>/home/smartadmin/apache-storm-0.9.6/conf/storm.yaml
echo 'storm.local.dir=/data/storm'>>/home/smartadmin/apache-storm-0.9.6/conf/storm.yaml



#启动 nimbus （c1 上）
nohup /usr/local/server/storm/bin/storm nimbus >/dev/null 2>&1 &

#启动 Supervisor (c2,c3 上)
nohup /usr/local/server/storm/bin/storm supervisor >/dev/null 2>&1 &

#启动 storm ui (c1 上)
nohup /usr/local/server/storm/bin/storm ui >/dev/null 2>&1 &

#关闭 storm
kill -9 `ps aux | grep storm | grep -v grep | awk '{print $2}'` > /dev/null 2>&1 &

#提交 topology
./storm jar  ~/Workdir/workspace/storm-demo/target/demo-1.0-SNAPSHOT.jar storm_demo.demo.App pro -c nimbus.host=c1