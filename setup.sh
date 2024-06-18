#!/bin/bash

# Upgrading and installing dependencies
echo "Upgrading and installing dependencies"
dnf upgrade -y
dnf install -y gcc make git perl

# Installing musl
echo "Installing musl"
curl -O "https://musl.libc.org/releases/musl-1.2.5.tar.gz"
tar vxf musl-1.2.5.tar.gz
cd musl-1.2.5/
./configure --prefix=/usr/local/
make && make install

# Installing Rust
echo "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain 1.72 -t x86_64-unknown-linux-musl -y
source $HOME/.cargo/env
