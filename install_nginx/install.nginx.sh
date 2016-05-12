#scp nginx-1.8.1.tar.gz
#scp openssl-1.0.1j.tar.gz
#scp pcre-8.37.tar.gz
#scp zlib-1.2.8.tar.gz






tar zxvf /home/smartadmin/pcre-8.37.tar.gz
cd /home/smartadmin/pcre-8.37
./configure
make
sudo make install

tar zxvf /home/smartadmin/zlib-1.2.8.tar.gz
cd /home/smartadmin/zlib-1.2.8
./configure
make 
sudo make install

tar zxvf /home/smartadmin/openssl-1.0.1j.tar.gz
cd openssl-1.0.1j
./config 
make 
sudo make install

tar zxvf nginx-1.8.1.tar.gz
cd /home/smartadmin/nginx-1.8.1
/home/smartadmin/nginx-1.8.1/configure --prefix=/usr/local/nginx
make 
sudo make install

cd /usr/local/nginx/conf
mkdir conf.d
mv proxyconf.sh  /usr/local/nginx/conf/conf.d/

#启动
/usr/local/nginx/sbin/nginx




