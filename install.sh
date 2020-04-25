#!/bin/sh

set -eu

dir=$(CDPATH="" cd -- "$(dirname -- "$0")" && pwd)

# constants
scripts_dir="${HOME}/.local/bin"

# print install steps
set -x

# create dirs
mkdir -p "${scripts_dir}"

# copy files
cp "${dir}/home/.bash_aliases" "${HOME}"
cp "${dir}/home/upgrade-all" "${scripts_dir}"

# update sources.list
sudo sh "${dir}/system/apt-sources.sh"
