#!/bin/bash

echo "=== APTITUDE"

cat > /etc/apt/sources.list << EOF
deb http://cdn.debian.net/debian/ wheezy main contrib non-free
deb-src http://cdn.debian.net/debian/ wheezy main contrib non-free

deb http://security.debian.org/ wheezy/updates main contrib non-free
deb-src http://security.debian.org/ wheezy/updates main contrib non-free

deb http://cdn.debian.net/debian/ wheezy-updates main contrib non-free
deb-src http://cdn.debian.net/debian/ wheezy-updates main contrib non-free

deb http://cdn.debian.net/debian/ wheezy-backports main contrib non-free

# postgres
deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main 9.3

# mongodb
deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen

# nginx 1.4 (with websockets support)
deb http://packages.dotdeb.org wheezy all
deb-src http://packages.dotdeb.org wheezy all

# node.js
deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu lucid main
deb-src http://ppa.launchpad.net/chris-lea/node.js/ubuntu lucid main

# redis
deb http://ppa.launchpad.net/chris-lea/redis-server/ubuntu lucid main
deb-src http://ppa.launchpad.net/chris-lea/redis-server/ubuntu lucid main
EOF

echo "Setup aptitude security keys for extra repositories"
# mongodb
apt-key adv --keyserver subkeys.pgp.net --recv 9ECBEC467F0CEB10
# postgres
wget -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
# dotdeb
wget -O - http://www.dotdeb.org/dotdeb.gpg | sudo apt-key add -
# ppa
KEY=<номер_ключа>; sudo gpg --recv-key --keyserver subkeys.pgp.net $KEY && sudo gpg --export $KEY | sudo apt-key add -
apt-key adv --keyserver subkeys.pgp.net --recv B9316A7BC7917B12



echo "aptitude update"
aptitude update && upgrade

echo "=== LOCALES"
aptitude install -y locales 
echo "LANG=en_US.UTF-8" > /etc/default/locale
cat > /etc/locale.gen << EOF
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF
locale-gen


echo "=== GIT"
aptitude install -y git-core


echo "=== VIM"
rm -R ~/.vim ~/.vimrc
git clone https://github.com/imbolc/.vim
ln -s ~/.vim/.vimrc ~

aptitude install -y vim-nox
update-alternatives --set editor /usr/bin/vim.nox


echo "=== INSTALL PACKAGES"
# psmsic --> pkill
# apache-utils --> ab
# libxml2-dev libxslt1-dev --> build lxml from source
# libcurl4-openssl-dev --> build pycurl from source
# libjpeg62-dev libfreetype6-dev --> build PIL from source
# postgresql-server-dev-all --> build psycopg from source
# libmysqld-dev --> build mysql driver from source
aptitude install -y libxml2-dev libxslt1-dev
aptitude install -y libcurl4-openssl-dev
aptitude install -y libjpeg62-dev libfreetype6-dev
aptitude install -y postgresql-server-dev-9.3 libmysqld-dev libmemcached-dev
aptitude install -y libtokyocabinet-dbg libtokyocabinet-dev libtokyocabinet9
aptitude install -y libevent-dev

aptitude install -y cron htop screen mc sudo apache2-utils gcc rsync
aptitude install -y nginx runit

aptitude install -y python python-setuptools python-dev
easy_install pip
pip install virtualenv fabric mercurial

# Enable sudo autocomplete
echo "complete -cf sudo" >> ~/.bashrc
