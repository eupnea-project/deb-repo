#!/bin/bash
# This script will build & pack keyd into a deb package
set -e

# clone keyd repo
git clone --depth=1 --branch=v2.4.2 https://github.com/rvaiya/keyd.git keyd-remote

# make dir
mkdir -p keyd/DEBIAN
mkdir -p keyd/usr/lib/systemd/system
mkdir -p keyd/usr/share/libinput
# the other dirs are automatically created by make install

# build keyd
cd keyd-remote
make
make DESTDIR=../keyd PREFIX='/usr' install

# Add postinst script to package
install -Dm 755 postinst-scripts/keyd-postinst eupnea-system/DEBIAN/postinst

# copy debian control file into package
cp control-files/keyd-control keyd/DEBIAN/control

# create package
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz keyd