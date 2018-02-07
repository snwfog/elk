#!/bin/bash

sudo apt-get -y dist-upgrade && sudo apt-get -y upgrade && sudo apt-get update && sudo apt-get -y install build-essential git-core
sudo apt-get -y install redis-server
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install default-jdk
echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
sudo apt-key adv --keyserver pool.sks-keyservers.net --recv-key A278B781FE4B2BDA
sudo apt-get update
sudo apt-get install cassandra
sudo systemctl start cassandra.service

sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
sudo apt-get install rbenv

" Gosh for gcc7 on latest ubuntu, need to apply this patch
" rbenv install -p 2.3.1 < <(curl -sSL https://bugs.ruby-lang.org/attachments/download/6655/ruby_2_3_gcc7.patch)
sudo apt-get install ruby-dev

cat /proc/cpuinfo | grep processor | wc -l
