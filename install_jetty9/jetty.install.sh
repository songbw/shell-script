#!/bin/sh
#wget http://download.eclipse.org/jetty/9.3.8.v20160314/dist/jetty-distribution-9.3.8.v20160314.tar.gz
scp -P22111 smartadmin@10.105.212.111:/home/smartadmin/jetty-distribution-9.3.8.v20160314.tar.gz .
sudo tar zxvf jetty-distribution-9.3.8.v20160314.tar.gz -C /data/server
sudo mv jetty-distribution-9.3.8.v20160314 jetty9
sudo mkdir -p /data/server/ui/run
sudo mkdir -p /data/server/core/run
sudo mkdir -p /data/server/ws/run
cd /data/server/jetty9
sudo cp -rf bin lib resources start.ini webapps /data/server/ui/
sudo cp -rf bin lib resources start.ini webapps /data/server/core/
sudo cp -rf bin lib resources start.ini webapps /data/server/ws/

sudo mkdir -p /data/server/ui/webapps/root
sudo mkdir -p /data/server/core/webapps/root
sudo mkdir -p /data/server/ws/webapps/root

sudo sed -i "s/# JETTY_HOME/JETTY_HOME=\/data\/server\/jetty9/g" /data/server/ui/bin/jetty.sh
sudo sed -i 's/# JETTY_HOME/JETTY_HOME=\/data\/server\/jetty9/g' /data/server/core/bin/jetty.sh
sudo sed -i 's/# JETTY_HOME/JETTY_HOME=\/data\/server\/jetty9/g' /data/server/ws/bin/jetty.sh


sudo sed -i 's/# JETTY_BASE/JETTY_BASE=\/data\/server\/ui/g' /data/server/ui/bin/jetty.sh
sudo sed -i 's/# JETTY_BASE/JETTY_BASE=\/data\/server\/core/g' /data/server/core/bin/jetty.sh
sudo sed -i 's/# JETTY_BASE/JETTY_BASE=\/data\/server\/ws/g' /data/server/ws/bin/jetty.sh


sudo sed -i 's/# JETTY_RUN/JETTY_RUN=$JETTY_BASE\/run/g' /data/server/ui/bin/jetty.sh
sudo sed -i 's/# JETTY_RUN/JETTY_RUN=$JETTY_BASE\/run/g' /data/server/core/bin/jetty.sh
sudo sed -i 's/# JETTY_RUN/JETTY_RUN=$JETTY_BASE\/run/g' /data/server/ws/bin/jetty.sh

sudo sed -i 's/# jetty.http.port=8080/jetty.http.port=8002/g' /data/server/ui/start.ini
sudo sed -i 's/# jetty.http.port=8080/jetty.http.port=8001/g' /data/server/core/start.ini
sudo sed -i 's/# jetty.http.port=8080/jetty.http.port=8003/g' /data/server/ws/start.ini
