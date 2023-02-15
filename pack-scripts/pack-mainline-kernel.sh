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
#curl --silent -L https://github.com/eupnea-linux/mainline-kernel/releases/latest/download/bzImage -o bzImage
#curl --silent -L https://github.com/eupnea-linux/mainline-kernel/releases/latest/download/headers.tar.xz  -o headers.tar.xz
#curl --silent -L https://github.com/eupnea-linux/mainline-kernel/releases/latest/download/modules.tar.xz -o modules.tar.xz
curl --silent -L https://github.com/eupnea-linux/mainline-kernel/releases/download/dev-build/bzImage -o bzImage
curl --silent -L https://github.com/eupnea-linux/mainline-kernel/releases/download/dev-build/headers.tar.xz -o headers.tar.xz
curl --silent -L https://github.com/eupnea-linux/mainline-kernel/releases/download/dev-build/modules.tar.xz -o modules.tar.xz

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
install -Dm 755 postinst-scripts/mainline-kernel-postinst postinst-scripts/eupnea-mainline-kernel/DEBIAN/postinst

# create packages
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz eupnea-mainline-kernel
dpkg-deb --build --root-owner-group -Z=xz eupnea-mainline-kernel-headers
dpkg-deb --build --root-owner-group -Z=xz eupnea-mainline-kernel-modules
