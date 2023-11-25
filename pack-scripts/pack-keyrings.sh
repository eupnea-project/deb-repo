#!/bin/bash
# This script will pack the eupnea keyring into 3 debian packages.
set -e

# create package dirs
mkdir -p eupnea-jammy-keyring/DEBIAN
mkdir -p eupnea-stable-keyring/DEBIAN
mkdir -p eupnea-mantic-keyring/DEBIAN

mkdir -p eupnea-jammy-keyring/usr/share/keyrings
mkdir -p eupnea-stable-keyring/usr/share/keyrings
mkdir -p eupnea-mantic-keyring/usr/share/keyrings

# Add eupnea public key to packages
cp configs/eupnea-keyring.gpg eupnea-jammy-keyring/usr/share/keyrings/eupnea-keyring.gpg
cp configs/eupnea-keyring.gpg eupnea-jammy-keyring/usr/share/keyrings/eupnea-keyring.gpg
cp configs/eupnea-keyring.gpg eupnea-jammy-keyring/usr/share/keyrings/eupnea-keyring.gpg

# copy debian control files into packages
cp control-files/keyring-jammy-control eupnea-jammy-keyring/DEBIAN/control
cp control-files/keyring-stable-control eupnea-stable-keyring/DEBIAN/control
cp control-files/keyring-mantic-control eupnea-mantic-keyring/DEBIAN/control

# copy repo config files into packages
cp configs/repo-configs/eupnea-jammy.sources eupnea-jammy-keyring/etc/apt/sources.list.d/eupnea-jammy.sources
cp configs/repo-configs/eupnea-stable.sources eupnea-stable-keyring/etc/apt/sources.list.d/eupnea-stable.sources
cp configs/repo-configs/eupnea-mantic.sources eupnea-mantic-keyring/etc/apt/sources.list.d/eupnea-mantic.sources

# create packages
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz eupnea-jammy-keyring
dpkg-deb --build --root-owner-group -Z=xz eupnea-stable-keyring
dpkg-deb --build --root-owner-group -Z=xz eupnea-mantic-keyring
