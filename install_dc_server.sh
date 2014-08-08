"""
    Author:Weixuan Kan
    E-mail:visionkan@gmail.com
"""

#!/bin/bash
#script to launch on a machine to set up the server of the data caching benchmark

#exit on error status
set -e 

#parameters

DOWNLOAD_DIR="$HOME/Download"


#prereq
sudo apt-get install -y gcc make


#commands

mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR

#libevent
echo "install libevent"
wget https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
cd $HOME
tar zxvf $DOWNLOAD_DIR/libevent-2.0.21-stable.tar.gz 
cd libevent-2.0.21-stable
./configure
make
sudo make install

#memcached
echo "install memcached"
cd $DOWNLOAD_DIR
wget http://memcached.googlecode.com/files/memcached-1.4.15.tar.gz

cd $HOME
tar zxvf $DOWNLOAD_DIR/memcached-1.4.15.tar.gz
cd memcached-1.4.15
./configure
make
sudo make install

#launch
echo "launch memcached"
memcached -t 4 -m 4096 -n 550 &

echo "Installation succeeded !"

exit 0
