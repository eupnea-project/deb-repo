#!/bin/bash
# This script will pack the chromeos kernel into 3 debian packages
set -e

# create dirs
mkdir -p eupnea-chromeos-kernel/DEBIAN
mkdir -p eupnea-chromeos-kernel-modules/DEBIAN
mkdir -p eupnea-chromeos-kernel-headers/DEBIAN

mkdir -p eupnea-chromeos-kernel/tmp/eupnea-kernel-update
mkdir -p eupnea-chromeos-kernel-modules/lib/modules
mkdir -p eupnea-chromeos-kernel-headers/usr/src

# Download kernel files
#curl --silent -L https://github.com/eupnea-linux/chromeos-kernel/releases/latest/download/bzImage -o bzImage
#curl --silent -L https://github.com/eupnea-linux/chromeos-kernel/releases/latest/download/headers.tar.xz  -o headers.tar.xz
#curl --silent -L https://github.com/eupnea-linux/chromeos-kernel/releases/latest/download/modules.tar.xz -o modules.tar.xz
curl --silent -L https://github.com/eupnea-linux/chromeos-kernel/releases/download/dev-build/bzImage -o bzImage
curl --silent -L https://github.com/eupnea-linux/chromeos-kernel/releases/download/dev-build/headers.tar.xz -o headers.tar.xz
curl --silent -L https://github.com/eupnea-linux/chromeos-kernel/releases/download/dev-build/modules.tar.xz -o modules.tar.xz

# copy kernel image to package
cp bzImage eupnea-chromeos-kernel/tmp/eupnea-kernel-update/bzImage

# Extract modules and headers into packages
tar xfpJ modules.tar.xz -C eupnea-chromeos-kernel-modules/lib/modules
tar xfpJ headers.tar.xz -C eupnea-chromeos-kernel-headers/usr/src

# copy debian control files into packages
cp control-files/chromeos-kernel-control eupnea-chromeos-kernel/DEBIAN/control
cp control-files/chromeos-kernel-modules-control eupnea-chromeos-kernel-modules/DEBIAN/control
cp control-files/chromeos-kernel-headers-control eupnea-chromeos-kernel-headers/DEBIAN/control

# Add postinst script to package
install -Dm 755 kernel-postinst postinst-scripts/eupnea-chromeos-kernel/DEBIAN/postinst

# create packages
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz eupnea-chromeos-kernel
dpkg-deb --build --root-owner-group -Z=xz eupnea-chromeos-kernel-headers
dpkg-deb --build --root-owner-group -Z=xz eupnea-chromeos-kernel-modules
