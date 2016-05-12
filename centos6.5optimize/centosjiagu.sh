#update os
yum update -y

#selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
setenforce 0

#welcome message
echo 'web server' >/etc/issue
echo 'web server' >/etc/redhat-release

#stop iptables
service iptables stop
chkconfig auditd off 
chkconfig blk-availability off
chkconfig ip6tables off
chkconfig postfix off
chkconfig netfs off

#del user
userdel adm
userdel lp
userdel shutdown
userdel halt
userdel uucp
userdel operator
userdel games
userdel gopher

#create administrator useuucp

useradd smartadmin
echo "Smartautotech@123" | passwd --stdin smartadmin

echo 'smartadmin	ALL=(ALL)	ALL'>>/etc/sudoers

echo 'net.ipv4.tcp_syncookies = 1'>>/etc/sysctl.conf #1是开启SYN Cookies，当出现SYN等待队列溢出时，启用Cookies来处，理，可防范少量SYN攻击，默认是0关闭 
echo 'net.ipv4.tcp_tw_reuse = 1'>>/etc/sysctl.conf #1是开启重用，允许讲TIME_AIT sockets重新用于新的TCP连接，默认是0关闭 
echo 'net.ipv4.tcp_tw_recycle = 1'>>/etc/sysctl.conf #TCP失败重传次数，默认是15，减少次数可释放内核资源 
echo 'net.ipv4.ip_local_port_range = 4096 65000'>>/etc/sysctl.conf #应用程序可使用的端口范围 
echo 'net.ipv4.tcp_max_tw_buckets = 5000'>>/etc/sysctl.conf #系统同时保持TIME_WAIT套接字的最大数量，如果超出这个数字，TIME_WATI套接字将立刻被清除并打印警告信息，默认180000 
echo 'net.ipv4.tcp_max_syn_backlog = 4096'>>/etc/sysctl.conf #进入SYN宝的最大请求队列，默认是1024 
echo 'net.core.netdev_max_backlog = 10240'>>/etc/sysctl.conf #允许送到队列的数据包最大设备队列，默认300 
echo 'net.core.somaxconn = 2048'>>/etc/sysctl.conf #listen挂起请求的最大数量，默认128 
echo 'net.core.wmem_default = 8388608'>>/etc/sysctl.conf #发送缓存区大小的缺省值 
echo 'net.core.rmem_default = 8388608'>>/etc/sysctl.conf #接受套接字缓冲区大小的缺省值（以字节为单位） 
echo 'net.core.rmem_max = 16777216'>>/etc/sysctl.conf #最大接收缓冲区大小的最大值 
echo 'net.core.wmem_max = 16777216'>>/etc/sysctl.conf #发送缓冲区大小的最大值 
echo 'net.ipv4.tcp_synack_retries = 2'>>/etc/sysctl.conf #SYN-ACK握手状态重试次数，默认5 
echo 'net.ipv4.tcp_syn_retries = 2'>>/etc/sysctl.conf #向外SYN握手重试次数，默认4 
echo 'net.ipv4.tcp_tw_recycle = 1'>>/etc/sysctl.conf #开启TCP连接中TIME_WAIT sockets的快速回收，默认是0关闭 
echo 'net.ipv4.tcp_max_orphans = 3276800'>>/etc/sysctl.conf #系统中最多有多少个TCP套接字不被关联到任何一个用户文件句柄上，如果超出这个数字，孤儿连接将立即复位并打印警告信息 
echo 'net.ipv4.tcp_mem = 94500000 915000000 927000000'>>/etc/sysctl.conf

#install packages
yum -y install lrzsz gcc gcc-c++ make pcre-devel zlib-devel openssl-devel ntp ntpdate rsync wget

# ntpdate cn.pool.ntp.org;clock -w

#crontab ntpdate
#10 * * * * /usr/sbin/ntpdate cn.pool.ntp.org;clock -w

echo '* soft nofile 65536'>>/etc/security/limits.conf
echo '* hard nofile 65536'>>/etc/security/limits.conf


echo 'auth required pam_tally2.so deny=5 unlock_time=180 even_deny_root root_unlock_time=180'>>/etc/pam.d/login

ipAdd=$(ifconfig eth0 | sed -n "2,2p" | awk '{print $2}')
OLD_IFS="$IFS"
IFS="."
port1=($ipAdd)
port3=${port1[3]}
len=`expr length $port3`
if [[ "$len" = 1 ]]; then
        port3=00$port3
fi
if [[ "$len" = 2 ]]; then
	port3=0$port3
fi


sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
sed -i "s/#Port 22/Port 22$port3/g" /etc/ssh/sshd_config
/etc/init.d/sshd reload

#iptables config
# iptables -F #清楚防火墙规则 
# iptables -L #查看防火墙规则
# iptables -A INPUT -p tcp --dport 80 -j ACCEPT
# iptables -A INPUT -p tcp --dport 22111 -j ACCEPT 
# iptables -A INPUT -p icmp -j ACCEPT
# iptables -P INPUT DROP

echo "alias vi='vim'">>/root/.bashrc
source /root/.bashrc

if grep -q /data /etc/fstab ; then uuid=notneed; echo /data already in fstab; else uuid=`mkfs.ext3 /dev/vdb > /dev/null 2>&1 && blkid /dev/vdb | awk '{print $2}'`;fi;if [[ $uuid == UUID* ]]; then echo $uuid /data ext3 noatime,acl,user_xattr 1 0 >> /etc/fstab; mount -a; else echo mkfs failed; fi;