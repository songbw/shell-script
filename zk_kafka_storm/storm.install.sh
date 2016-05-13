#!/bin/sh
cd /tmp
#wget -c http://ftp.jaist.ac.jp/pub/apache/storm/apache-storm-0.9.6/apache-storm-0.9.6.tar.gz
scp -P22111 smartadmin@10.105.212.111:/home/smartadmin/apache-storm-0.9.6.tar.gz .
sudo tar xvzf apache-storm-0.9.6.tar.gz -C /data/server

#cp -r apache-storm-0.9.6 /usr/local/server/storm
#cd /usr/local/server/storm/conf

#mkdir -p /data/storm


#打开 storm.yaml 修改 storm.zookeeper.servers 为

#sed -i 's/# storm.zookeeper.servers:/storm.zookeeper.servers:/g' /home/smartadmin/apache-storm-0.9.6/conf/storm.yaml
#sed -i 's/#     - "server1"/    - "c1"/g' /home/smartadmin/apache-storm-0.9.6/conf/storm.yaml
#sed -i 's/#     - "server2"/    - "c2"/g' /home/smartadmin/apache-storm-0.9.6/conf/storm.yaml
#sed -i 's/# nimbus.host: "nimbus"/nimbus.host: "c1"/g' /home/smartadmin/apache-storm-0.9.6/conf/storm.yaml
sudo bash -c "echo 'storm.zookeeper.servers:'>>/data/server/apache-storm-0.9.6/conf/storm.yaml"
sudo bash -c "echo '    - \"c1\"'>>/data/server/apache-storm-0.9.6/conf/storm.yaml"
sudo bash -c "echo '    - \"c2\"'>>/data/server/apache-storm-0.9.6/conf/storm.yaml"
sudo bash -c "echo 'nimbus.host: \"c1\"'>>/data/server/apache-storm-0.9.6/conf/storm.yaml"
sudo bash -c "echo 'storm.local.dir=/data/storm'>>/data/server/apache-storm-0.9.6/conf/storm.yaml"



#启动 nimbus （c1 上）
#nohup /usr/local/server/storm/bin/storm nimbus >/dev/null 2>&1 &

#启动 Supervisor (c2,c3 上)
#nohup /usr/local/server/storm/bin/storm supervisor >/dev/null 2>&1 &

#启动 storm ui (c1 上)
#nohup /usr/local/server/storm/bin/storm ui >/dev/null 2>&1 &

#关闭 storm
#kill -9 `ps aux | grep storm | grep -v grep | awk '{print $2}'` > /dev/null 2>&1 &

#提交 topology
#./storm jar  ~/Workdir/workspace/storm-demo/target/demo-1.0-SNAPSHOT.jar storm_demo.demo.App pro -c nimbus.host=c1