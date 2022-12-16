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
git clone --depth=1 https://github.com/eupnea-linux/postinstall-scripts.git --branch=move-to-packages
git clone --depth=1 https://github.com/eupnea-linux/audio-scripts
git clone --depth=1 https://github.com/eupnea-linux/systemd-services --branch=move-to-packages

# move scripts into package
mv postinstall-scripts/user-scripts/* eupnea-utils/usr/bin
mv audio-scripts/setup-audio eupnea-utils/usr/bin

# Move systemd services into package
cp systemd-services/eupnea-update.service eupnea-utils/etc/systemd/system/
cp systemd-services/eupnea-postinstall.service eupnea-utils/etc/systemd/system/
cp systemd-services/eupnea-update.timer eupnea-utils/etc/systemd/system/

# Move libs into package
mv postinstall-scripts/system-scripts/* eupnea-utils/usr/lib/eupnea
mv postinstall-scripts/functions.py eupnea-utils/usr/lib/eupnea

# move postinstall configs into package
mv postinstall-scripts/configs/* eupnea-utils/etc/eupnea
# move audio config into package
mv audio-scripts/configs/* eupnea-utils/etc/eupnea

# copy debian control files into package
cp utils-control eupnea-utils/DEBIAN/control
# Add postinst script to package
install -Dm 755 postinst eupnea-system/DEBIAN/utils-postinst

# create package
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz eupnea-utils
