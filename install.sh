#!/bin/bash

set -eu

this=$(realpath ${BASH_SOURCE[0]})
dir=$(dirname $this)

# copy files
cp "${dir}/home/.bash_aliases" ~/
cp "${dir}/home/.bash_functions" ~/

# update ~/.bashrc
cat >> ~/.bashrc <<EOF

# Include simple functions

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi
EOF

# source changes
. ~/.bashrc

# update sources.list
sudo bash "$dir/system/apt-sources.sh"
