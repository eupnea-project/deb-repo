#!/bin/bash
# This script will pack eupnea-utils into a debian package
set -e

# create dirs
mkdir -p eupnea-utils/DEBIAN
mkdir -p eupnea-utils/usr/bin
mkdir -p eupnea-utils/usr/lib/eupnea
mkdir -p eupnea-utils/etc/eupnea
mkdir -p eupnea-utils/etc/systemd/system/

# Clone postinstall + audio repo
git clone --depth=1 https://github.com/eupnea-linux/postinstall-scripts.git
git clone --depth=1 https://github.com/eupnea-linux/audio-scripts
git clone --depth=1 https://github.com/eupnea-linux/systemd-services

# Copy scripts into package
install -Dm 755 postinstall-scripts/user-scripts/* eupnea-utils/usr/bin
install -Dm 755 audio-scripts/setup-audio eupnea-utils/usr/bin

# Copy systemd services into package
cp systemd-services/eupnea-update.service eupnea-utils/etc/systemd/system/
cp systemd-services/eupnea-postinstall.service eupnea-utils/etc/systemd/system/
cp systemd-services/eupnea-update.timer eupnea-utils/etc/systemd/system/

# Copy libs into package
cp postinstall-scripts/system-scripts/* eupnea-utils/usr/lib/eupnea
cp postinstall-scripts/functions.py eupnea-utils/usr/lib/eupnea

# Copy configs into package
cp -r postinstall-scripts/configs/* eupnea-utils/etc/eupnea
cp -r audio-scripts/configs/* eupnea-utils/etc/eupnea

# copy debian control files into package
cp utils-control eupnea-utils/DEBIAN/control
# Add postinst script to package
install -Dm 755 utils-postinst eupnea-utils/DEBIAN/postinst

# create package
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz eupnea-utils
