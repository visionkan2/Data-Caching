#!/bin/bash
#script to launch on a machine to set up the client of the data caching benchmark

#WARNING ! please dont forget to modify SERVER variable before launching !!!


#if the script ends correctly, the client is set up

#config
#works correctly on a ubuntu server 13.04 large instance

#exit on error status
set -e 

#parameters

DOWNLOAD_DIR="$HOME/Download"
SERVER="SERVER"
PORT="11211"

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

#benchmark
echo "install benchmark"
cd $DOWNLOAD_DIR
wget http://parsa.epfl.ch/cloudsuite/software/memcached.tar.gz

cd $HOME
tar zxvf $DOWNLOAD_DIR/memcached.tar.gz
cd memcached/memcached_client/
export BENCHMARK_HOME=`pwd`
echo BENCHMARK_HOME=`pwd` >> $HOME/.pam_environment

sed -i 's/.*gcc.*/\tgcc -O3  -Wall -pthread -D_GNU_SOURCE  *.c -levent -lm -o loader/g' $BENCHMARK_HOME/Makefile

make
echo "$SERVER, $PORT" > $BENCHMARK_HOME/servers.txt

echo "warm up of server"
./loader -a ../twitter_dataset/twitter_dataset_unscaled -o ../twitter_dataset/twitter_dataset_30x -s servers.txt -w 1 -S 30 -D 4096 -j -T 1 

exit 0
