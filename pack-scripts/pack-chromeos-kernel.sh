#!/bin/bash
# This script will pack the chromeos kernel into 3 debian packages
set -e

# create dirs
mkdir -p eupnea-chromeos-kernel/DEBIAN
mkdir -p eupnea-chromeos-kernel-modules/DEBIAN
mkdir -p eupnea-chromeos-kernel-headers/DEBIAN

mkdir -p eupnea-chromeos-kernel/boot
mkdir -p eupnea-chromeos-kernel-modules/lib/modules
mkdir -p eupnea-chromeos-kernel-headers/usr/src

# Download kernel files
#curl --silent -LO https://github.com/eupnea-linux/chromeos-kernel/releases/latest/download/bzImage
#curl --silent -LO https://github.com/eupnea-linux/chromeos-kernel/releases/latest/download/headers.tar.xz
#curl --silent -LO https://github.com/eupnea-linux/chromeos-kernel/releases/latest/download/modules.tar.xz
curl --silent -LO https://github.com/eupnea-linux/chromeos-kernel/releases/download/dev-build/bzImage
curl --silent -LO https://github.com/eupnea-linux/chromeos-kernel/releases/download/dev-build/headers.tar.xz
curl --silent -LO https://github.com/eupnea-linux/chromeos-kernel/releases/download/dev-build/modules.tar.xz

# read kernel version
KERNEL_VERSION=$(file -bL ./bzImage | grep -o 'version [^ ]*' | cut -d ' ' -f 2) # get kernel version from bzImage

# copy kernel image to /boot
cp bzImage eupnea-chromeos-kernel/boot/vmlinuz-eupnea-chromeos

# Extract modules and headers into packages
tar xfpJ modules.tar.xz -C eupnea-chromeos-kernel-modules/lib/modules
tar xfpJ headers.tar.xz -C eupnea-chromeos-kernel-headers/usr/src

# copy debian control files into packages
cp control-files/chromeos-kernel-control eupnea-chromeos-kernel/DEBIAN/control
cp control-files/chromeos-kernel-modules-control eupnea-chromeos-kernel-modules/DEBIAN/control
cp control-files/chromeos-kernel-headers-control eupnea-chromeos-kernel-headers/DEBIAN/control

# Add postinst script to package
install -Dm 755 postinst-scripts/chromeos-kernel-postinst eupnea-chromeos-kernel/DEBIAN/postinst

# add modules link into headers package
mkdir -p eupnea-chromeos-kernel-headers/lib/modules/"$KERNEL_VERSION"
ln -s /usr/src/linux-headers-"$KERNEL_VERSION"/ eupnea-chromeos-kernel-headers/lib/modules/"$KERNEL_VERSION"/build

# create packages
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz eupnea-chromeos-kernel
dpkg-deb --build --root-owner-group -Z=xz eupnea-chromeos-kernel-headers
dpkg-deb --build --root-owner-group -Z=xz eupnea-chromeos-kernel-modules
