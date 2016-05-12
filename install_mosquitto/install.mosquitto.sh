wget http://mosquitto.org/files/source/mosquitto-1.4.8.tar.gz
wget http://c-ares.haxx.se/download/c-ares-1.10.0.tar.gz
tar xzf mosquitto-1.4.8.tar.gz
tar xvf c-ares-1.10.0.tar.gz
cd c-ares-1.10.0
./configure
 sudo yum install libuuid-devel
make
sudo make install
cd ../mosquitto-1.4.8




#创建用户
sudo groupadd mosquitto
sudo useradd -g  mosquitto mosquitto
#修改配置文件
sudo mv /etc/mosquitto/mosquitto.conf.example /etc/mosquitto/mosquitto.conf


# 服务进程的PID
#pid_file /var/run/mosquitto.pid
 
# 服务进程的系统用户
#user mosquitto
 
# 服务绑定的IP地址
#bind_address
 
# 服务绑定的端口号
#port 1883
 
# 允许的最大连接数，-1表示没有限制
#max_connections -1
 
# 允许匿名用户
#allow_anonymous true

#启动
mosquitto -c /etc/mosquitto/mosquitto.conf -d


#找不到链接库，通过locate或find命令找到libwebsockets.so.4.0.0，将其目录添加至ldconfg配置中
#//添加路径
#sudo nano /etc/ld.so.conf.d/liblocal.conf
#/usr/local/lib64
#/usr/local/lib
#//刷新
#sudo ldconfig


#程序文件将默认安装到以下位置
#路径	             程序文件
#/usr/local/sbin	mosquiotto server
#/etc/mosquitto	    configuration
#/usr/local/bin	    utility command

#客户端测试
#新建两个shell端口A/B
#A 订阅主题：
#mosquitto_sub -t location
#B 推送消息：
#mosquitto_pub -t location -h localhost -m "new location"