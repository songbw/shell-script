#!/bin/sh
cd /tmp
tar zxvf jdk-8u77-linux-x64.tar.gz -C /opt
sudo yum -y install htop
sudo cat >> /etc/profile <<EOF
export JAVA_HOME=/opt/jdk1.8.0_77
export PATH=\$JAVA_HOME/bin:\$PATH
export CLASSPATH=.:\$JAVA_HOME/lib/tools.jar:\$JAVA_HOME/lib/dt.jar:\$CLASSPATH
#export JAVA_OPTIONS="-server -Xms4096m -Xmx4096m -XX:PermSize=512M"
export JAVA_OPTIONS="-server -Xms512m -Xmx1024m -XX:PermSize=256M"
EOF
sudo source /etc/profile