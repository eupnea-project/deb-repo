#!/bin/bash
# This script will pack the mainline kernel into 3 debian packages
set -e

# create dirs
mkdir -p eupnea-mainline-kernel/DEBIAN
mkdir -p eupnea-mainline-kernel-modules/DEBIAN
mkdir -p eupnea-mainline-kernel-headers/DEBIAN

mkdir -p eupnea-mainline-kernel/boot
mkdir -p eupnea-mainline-kernel-modules/lib/modules
mkdir -p eupnea-mainline-kernel-headers/usr/src

# Download kernel files
curl --silent -LO https://github.com/eupnea-linux/mainline-kernel/releases/latest/download/bzImage
curl --silent -LO https://github.com/eupnea-linux/mainline-kernel/releases/latest/download/headers.tar.xz
curl --silent -LO https://github.com/eupnea-linux/mainline-kernel/releases/latest/download/modules.tar.xz

# read kernel version
KERNEL_VERSION=$(file -bL ./bzImage | grep -o 'version [^ ]*' | cut -d ' ' -f 2) # get kernel version from bzImage

# copy kernel image to /boot
cp bzImage eupnea-mainline-kernel/boot/vmlinuz-eupnea-mainline

# Extract modules and headers into packages
tar xfpJ modules.tar.xz -C eupnea-mainline-kernel-modules/lib/modules
tar xfpJ headers.tar.xz -C eupnea-mainline-kernel-headers/usr/src

# copy debian control files into packages
cp control-files/mainline-kernel-control eupnea-mainline-kernel/DEBIAN/control
cp control-files/mainline-kernel-modules-control eupnea-mainline-kernel-modules/DEBIAN/control
cp control-files/mainline-kernel-headers-control eupnea-mainline-kernel-headers/DEBIAN/control

# Add postinst script to package
install -Dm 755 postinst-scripts/mainline-kernel-postinst eupnea-mainline-kernel/DEBIAN/postinst

# add modules link into headers package
mkdir -p eupnea-mainline-kernel-headers/lib/modules/"$KERNEL_VERSION"
ln -s /usr/src/linux-headers-"$KERNEL_VERSION"/ eupnea-mainline-kernel-headers/lib/modules/"$KERNEL_VERSION"/build

# create packages
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz eupnea-mainline-kernel
dpkg-deb --build --root-owner-group -Z=xz eupnea-mainline-kernel-headers
dpkg-deb --build --root-owner-group -Z=xz eupnea-mainline-kernel-modules
