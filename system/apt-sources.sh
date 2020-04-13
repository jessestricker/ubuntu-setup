#!/bin/bash

set -eu

# example:
# deb http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse

uri="http://archive.ubuntu.com/ubuntu"
distro=$(lsb_release --codename --short)
suites="$distro ${distro}-updates ${distro}-security ${distro}-backports"
comps="main restricted universe multiverse"
file="/etc/apt/sources.list"
backup_file="${file}.bak-$(date --utc +%Y%m%d-%H%M%S)"

# do backup
mv "$file" "$backup_file"

# echo into file
for suite in $suites; do
	line="deb $uri $suite $comps"
	echo "$line" >> "$file"
done

# clean and update
sudo apt clean
sudo apt update
