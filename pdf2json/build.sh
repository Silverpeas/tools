#!/usr/bin/env bash

source project

echo "Install missing packages for building ${project}"
test -e /usr/bin/yum && sudo yum install wget zip gcc gcc-c++ openssh-clients
test -e /usr/bin/apt-get && sudo apt-get install wget zip build-essential autoconf openssh-client

echo "Make the directory structure for the installation"
test -e /tmp/usr && rm -rf /tmp/usr
mkdir -p /tmp/usr/local

echo "Build ${project}"
wget -nc ${download} \
  && mkdir ${project} \
  && tar zxvf ${project}-${version}.tar.gz -C ${project} \
  && cd ${project} \
  && ./configure --prefix=/tmp/usr/local \
  && make && make install \
  && cd .. \
  && rm -rf ${project}* \
  && echo "Package the ${project} binaries and push it to the Silverpeas Web Site" \
  && cd /tmp \
  && zip -r ${project}-bin-${version}.zip usr \
  && scp ${project}-bin-${version}.zip silverpeas@www.silverpeas.org:/var/www/files/

