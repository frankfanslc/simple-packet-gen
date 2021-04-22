#!/bin/bash

dpdk_dir=$(readlink -f $(dirname $0))/dpdk
build_dir=$dpdk_dir/build
install_dir=$build_dir/install

sudo whoami

# Fetch DPDK repository
if [[ ! -d $dpdk_dir || -z $(ls $dpdk_dir/*) ]]; then
    echo "Fetching DPDK repository from git..."
    git clone https://dpdk.org/git/dpdk-stable $dpdk_dir
fi

# Checkout DPDK version tag
cd $dpdk_dir
git checkout v19.11.8

# Create the DPDK build dir
if [[ -d $build_dir ]]; then
    read -p "DPDK build dir exists. Do you want to delete it? [y|N]" ans
    if [[ ! -z $ans || $ans =~ [Yy] ]]; then
        rm $build_dir
    fi
fi

echo "Configuring DPDK..."
meson -Dprefix=$install_dir build
cd build

# Make DPDK, install locally
echo "Making DPDK..."
ninja
sudo ninja install
user=$USER
sudo chown $user $dpdk_dir -R

