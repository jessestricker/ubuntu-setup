#!/bin/sh

set -eu

# ensure root user
if [ "$(id -u)" -ne 0 ]; then
	echo "error: this script must be run as root"
	exit 1
fi

# define constants and path
repo_url="http://archive.ubuntu.com/ubuntu"
distro=$(lsb_release --codename --short)
suites="${distro} ${distro}-updates ${distro}-security ${distro}-backports"
comps="main restricted universe multiverse"

file="/etc/apt/sources.list"
backup_file="${file}.bak-$(date --utc +%Y%m%d-%H%M%S)"

# do backup
echo "backing up ${file} -> ${backup_file}"
mv "${file}" "${backup_file}"

# echo into file
for suite in ${suites}; do
	line="deb ${repo_url} ${suite} ${comps}"
	echo "${line}" >> "${file}"
done

# display
echo "the new content of ${file}:"
cat "${file}"

# clean and update
sudo apt-get clean
sudo apt-get update
