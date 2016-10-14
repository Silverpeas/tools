#!/usr/bin/env bash

source project

echo "Install missing packages for building ${project}"
test -e /usr/bin/yum && sudo yum install wget zip zlib-devel libjpeg-devel giflib-devel freetype-devel gcc gcc-c++ openssh-clients
test -e /usr/bin/apt-get && sudo apt-get install wget zip build-essential autoconf zlib1g-dev libjpeg-dev libfreetype6-dev openssh-client

echo "Make the directory structure for the installation"
test -e /tmp/usr && rm -rf /tmp/usr
mkdir -p /tmp/usr/local

echo "Build ${project}"
wget -nc ${download} \
  && tar zxvf ${project}-${version}.tar.gz \
  && cd ${project}-${version} \
  && ./configure --prefix=/tmp/usr/local \
  && sed -i -e 's/rm -f $(pkgdatadir)\/swfs\/default_viewer.swf -o -L $(pkgdatadir)\/swfs\/default_viewer.swf/# rm -f $(pkgdatadir)\/swfs\/default_viewer.swf -o -L $(pkgdatadir)\/swfs\/default_viewer.swf/g' swfs/Makefile \
  && sed -i -e 's/rm -f $(pkgdatadir)\/swfs\/default_loader.swf -o -L $(pkgdatadir)\/swfs\/default_loader.swf/# rm -f $(pkgdatadir)\/swfs\/default_loader.swf -o -L $(pkgdatadir)\/swfs\/default_loader.swf/g' swfs/Makefile \
  && make && make install \
  && cd .. \
  && rm -rf ${project}* \
  && echo "Package the ${project} binaries and push it to the Silverpeas Web Site" \
  && cd /tmp \
  && zip -r ${project}-bin-${version}.zip usr \
  && scp ${project}-bin-${version}.zip silverpeas@www.silverpeas.org:/var/www/files/

