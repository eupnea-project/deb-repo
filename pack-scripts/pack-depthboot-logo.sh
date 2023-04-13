#!/bin/bash
# This script will pack depthboot-logo into a deb package
set -e

# Download the alpine busybox-static package
curl -LO https://dl-cdn.alpinelinux.org/alpine/v3.17/main/x86_64/busybox-static-1.35.0-r29.apk
# clone the eupnea logo repo
git clone --depth=1 https://github.com/eupnea-linux/logo.git

# make dirs
mkdir -p busybox-extracted
mkdir -p depthboot-logo/usr/bin
mkdir -p depthboot-logo/usr/share/eupnea
mkdir -p depthboot-logo/usr/lib/systemd/system
mkdir -p depthboot-logo/DEBIAN

# Extract the alpine package
tar xfpz busybox-static-1.35.0-r29.apk --warning=no-unknown-keyword -C busybox-extracted
# copy busybox binary into the package
install -Dm755 busybox-extracted/bin/busybox.static depthboot-logo/usr/bin/busybox-alpine.static

# copy depthboot logo into the package
cp logo/depthboot.ppm depthboot-logo/usr/share/eupnea/eupnea_boot_logo.ppm

# Copy config for centering the logo
cp logo/center-splash.conf depthboot-logo/usr/share/eupnea/center-splash.conf

# add systemd service
cp logo/eupnea-boot-splash.service depthboot-logo/usr/lib/systemd/system/eupnea-boot-splash.service

# Add postinst script to package
install -Dm 755 postinst-scripts/depthboot-logo-postinst depthboot-logo/DEBIAN/postinst

# copy debian control file into package
cp control-files/depthboot-logo-control depthboot-logo/DEBIAN/control

# create package
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz depthboot-logo
