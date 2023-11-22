#!/bin/bash
# This script will pack eupnea-utils into a debian package
set -e

# create dirs
mkdir -p eupnea-utils/DEBIAN
mkdir -p eupnea-utils/usr/bin
mkdir -p eupnea-utils/usr/lib/eupnea
mkdir -p eupnea-utils/usr/lib/systemd/system-sleep/
mkdir -p eupnea-utils/usr/share/eupnea
mkdir -p eupnea-utils/etc/systemd/system/

# Clone utils repo
git clone --depth=1 https://github.com/eupnea-project/eupnea-utils.git remote-eupnea-utils

# Copy scripts into package
install -Dm 755 remote-eupnea-utils/user-scripts/* eupnea-utils/usr/bin

# Copy systemd services into package
cp remote-eupnea-utils/systemd-services/* eupnea-utils/etc/systemd/system

# Add sleep trigger
install -Dm 755 remote-eupnea-utils/configs/fix-touchscreen-on-wakeup.sh eupnea-utils/usr/lib/systemd/system-sleep/fix-touchscreen-on-wakeup.sh

# Copy libs into package
cp remote-eupnea-utils/system-scripts/* eupnea-utils/usr/lib/eupnea
cp remote-eupnea-utils/functions.py eupnea-utils/usr/lib/eupnea

# Copy configs into package
cp -r remote-eupnea-utils/configs/deep_sleep_block.conf eupnea-utils/usr/share/eupnea/deep_sleep_block.conf

# copy debian control files into package
cp control-files/utils-control eupnea-utils/DEBIAN/control
# Add postinst script to package
install -Dm 755 postinst-scripts/utils-postinst eupnea-utils/DEBIAN/postinst

# create package
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz eupnea-utils
