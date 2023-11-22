#!/bin/bash
# This script will build & pack keyd into a deb package
set -e

# clone repos
git clone --depth=1 https://github.com/rvaiya/keyd.git keyd-remote
git clone --depth=1 https://github.com/eupnea-project/eupnea-utils.git

# make dir
mkdir -p keyd/DEBIAN
mkdir -p keyd/usr/lib/systemd/system
mkdir -p keyd/usr/share/libinput
mkdir -p keyd/usr/share/eupnea
# the other dirs are automatically created by make install

# build keyd
cd keyd-remote
make
make DESTDIR=../keyd PREFIX='/usr' install
cd ..

# add quirks file
cp configs/keyd.quirks keyd/usr/share/libinput

# add keyboard configs
cp -r eupnea-utils/configs/keyboard-layouts keyd/usr/share/eupnea/

# Add postinst script to package
install -Dm 755 postinst-scripts/keyd-postinst keyd/DEBIAN/postinst

# copy debian control file into package
cp control-files/keyd-control keyd/DEBIAN/control

# create package
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz keyd
