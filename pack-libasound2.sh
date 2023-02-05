#!/bin/bash
# This script will repack libasound2 and libasound2-data from Ubuntu 22.10 for Ubuntu 22.04

# NOTE:
# libasound2 normal has an underscore in the package name, i.e. libasound2_1.2.7.2-1_amd64.deb
# libasound2 data has a dash in the package name, i.e. libasound2-data_1.2.7.2-1_all.deb
set -e

# create dir
mkdir -p libasound2-eupnea/DEBIAN
mkdir -p libasound2-eupnea/usr

# Replace jammy repos with kinetic repos
sudo sed -i 's/jammy/kinetic/g' /etc/apt/sources.list
sudo apt-get update -y

# Download libasound2 and libasound2-data
apt-get download libasound2 libasound2-data

# Unpack libasound2 and libasound2-data with control files
dpkg-deb -R libasound2_*.deb libasound2-normal
dpkg-deb -R libasound2-*.deb libasound2-data

# Combine libasound2 and libasound2-data into one package
cp -r libasound2-normal/usr/* libasound2-eupnea/usr/

# Copy DEBIAN files from normal package
cp -r libasound2-normal/DEBIAN/shlibs libasound2-eupnea/DEBIAN/shlibs
cp -r libasound2-normal/DEBIAN/symbols libasound2-eupnea/DEBIAN/symbols
cp -r libasound2-normal/DEBIAN/triggers libasound2-eupnea/DEBIAN/triggers

# copy debian control file into package
cp libasound2-control libasound2-eupnea/DEBIAN/control

# create package
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz libasound2-eupnea
