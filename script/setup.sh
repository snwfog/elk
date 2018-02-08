#!/bin/bash

sudo apt-get -y dist-upgrade && sudo apt-get -y upgrade && sudo apt-get update && sudo apt-get -y install build-essential git-core
sudo apt-get -y install redis-server
sudo apt-get update
sudo apt-get upgrade
#sudo apt-get install oracle-java8-installer
sudo apt-get install default-jre
echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
sudo apt-key adv --keyserver pool.sks-keyservers.net --recv-key A278B781FE4B2BDA
sudo apt-get update
sudo apt-get -y install cassandra
sudo systemctl start cassandra.service

sudo apt-get -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
#sudo apt-get -y install rbenv ruby-build

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

" Gosh for gcc7 on latest ubuntu, need to apply this patch
" rbenv install -p 2.3.1 < <(curl -sSL https://bugs.ruby-lang.org/attachments/download/6655/ruby_2_3_gcc7.patch)
sudo apt-get -y install ruby-dev

source ~/.bashrc
cat /proc/cpuinfo | grep processor | wc -l
