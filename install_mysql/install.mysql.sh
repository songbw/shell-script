#!/bin/sh
#https://blog.linuxeye.com/432.html

yum -y install gcc gcc-c++ ncurses ncurses-devel cmake

#wget http://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz
#wget http://cdn.mysql.com/Downloads/MySQL-5.7/mysql-5.7.11.tar.gz

scp -P22111 smartadmin@10.105.212.111:/home/smartadmin/boost_1_59_0.tar.gz .
scp -P22111 smartadmin@10.105.212.111:/home/mysql-5.7.11.tar.gz .

useradd -M -s /sbin/nologin mysql

tar xzf boost_1_59_0.tar.gz
tar xzf mysql-5.7.11.tar.gz
mkdir -p /data/mysql
cd mysql-5.7.11

sudo cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/data/mysql -DDOWNLOAD_BOOST=1 -DWITH_BOOST=../boost_1_59_0 -DSYSCONFDIR=/etc -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_MYISAM_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1 -DENABLE_DTRACE=0 -DDEFAULT_CHARSET=utf8mb4 -DDEFAULT_COLLATION=utf8mb4_general_ci -DWITH_EMBEDDED_SERVER=1

sudo make -j `grep processor /proc/cpuinfo | wc -l`

sudo make install

sudo /bin/cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld

sudo chmod +x /etc/init.d/mysqld
sudo chkconfig --add mysqld
sudo chkconfig mysqld on

sudo bash -c "cat > /etc/my.cnf << EOF
[client]
port = 3306
socket = /tmp/mysql.sock
default-character-set = utf8mb4
[mysqld]
port = 3306
socket = /tmp/mysql.sock
basedir = /usr/local/mysql
datadir = /data/mysql
pid-file = /data/mysql/mysql.pid
user = mysql
bind-address = 0.0.0.0
server-id = 1
init-connect = 'SET NAMES utf8mb4'
character-set-server = utf8mb4
#skip-name-resolve
#skip-networking
back_log = 300
max_connections = 1000
max_connect_errors = 6000
open_files_limit = 65535
table_open_cache = 128
max_allowed_packet = 4M
binlog_cache_size = 1M
max_heap_table_size = 8M
tmp_table_size = 16M
read_buffer_size = 2M
read_rnd_buffer_size = 8M
sort_buffer_size = 8M
join_buffer_size = 8M
key_buffer_size = 4M
thread_cache_size = 8
query_cache_type = 1
query_cache_size = 8M
query_cache_limit = 2M
ft_min_word_len = 4
log_bin = mysql-bin
binlog_format = mixed
expire_logs_days = 30
log_error = /data/mysql/mysql-error.log
slow_query_log = 1
long_query_time = 1
slow_query_log_file = /data/mysql/mysql-slow.log
performance_schema = 0
explicit_defaults_for_timestamp
#lower_case_table_names = 1
skip-external-locking
default_storage_engine = InnoDB
#default-storage-engine = MyISAM
innodb_file_per_table = 1
innodb_open_files = 500
innodb_buffer_pool_size = 64M
innodb_write_io_threads = 4
innodb_read_io_threads = 4
innodb_thread_concurrency = 0
innodb_purge_threads = 1
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 2M
innodb_log_file_size = 32M
innodb_log_files_in_group = 3
innodb_max_dirty_pages_pct = 90
innodb_lock_wait_timeout = 120
bulk_insert_buffer_size = 8M
myisam_sort_buffer_size = 8M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1
interactive_timeout = 28800
wait_timeout = 28800
[mysqldump]
quick
max_allowed_packet = 16M
[myisamchk]
key_buffer_size = 8M
sort_buffer_size = 8M
read_buffer = 4M
write_buffer = 4M
EOF"

#初始化数据库
sudo /usr/local/mysql/bin/mysqld --initialize-insecure --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql


dbrootpwd=root

sudo /usr/local/mysql/bin/mysql -e "grant all privileges on *.* to root@'127.0.0.1' identified by \"$dbrootpwd\" with grant option;"
#sudo /usr/local/mysql/bin/mysql -e "grant all privileges on *.* to root@'localhost' identified by \"$dbrootpwd\" with grant option;"

#启动Mysql
sudo /etc/init.d/mysqld restart

#sudo /usr/local/mysql/bin/mysql -e "grant all privileges on *.* to root@'127.0.0.1' identified by 'Smartautotech@123' with grant option;"

#修改Mysql密码
#sudo  /usr/local/mysql/bin/mysqladmin -u root -p password 123456

#mysql 安装目录
#/usr/local/mysql/bin/