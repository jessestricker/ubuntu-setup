#!/bin/bash

upgrade-all() {
    # define echo styles
    info=$(setterm --foreground yellow)
    crit=$(setterm --foreground white; setterm --background red)
    reset=$(setterm --default)

    echo "${info}### APT: fetching packet lists${reset}"
    sudo apt update

    echo "${info}### APT: upgrading packages${reset}"
    sudo apt upgrade --auto-remove --purge

    echo "${info}### Snap: refreshing packages${reset}"
    sudo snap refresh

    if [ -f /var/run/reboot-required ]; then
        echo "${crit}### A reboot is required, you should do it now!${reset}"
    fi
}
