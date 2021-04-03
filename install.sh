#!/bin/bash

set -eu

# paths
dir=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
scripts_dir="${HOME}/bin"

# set up user
mkdir -p "${scripts_dir}"
cp "${dir}/home/.bash_aliases" "${HOME}"
echo "set useful bash aliases in ~/.bash_aliases"
cp "${dir}/home/upgrade-all" "${scripts_dir}"
echo "installed upgrade script to ${scripts_dir}"

# set up system
sudo "${dir}/gen-apt-sources.sh"

# print finish message
echo
echo "all set up! to enable the new commands run '. ~/.profile'"
