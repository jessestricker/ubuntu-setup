#!/bin/bash

upgrade-all() {
	# define echo styles
	info=$(setterm --foreground cyan --bold on)
	crit=$(setterm --foreground white --background red --bold on)
	reset=$(setterm --default)

	echo "${info}### APT: fetching packet lists${reset}"
	sudo apt update

	echo "${info}### APT: upgrading packages${reset}"
	sudo apt upgrade --auto-remove --purge

	if which "snap" > /dev/null; then
		echo "${info}### Snap: refreshing packages${reset}"
		sudo snap refresh
	fi

	if [ -f /var/run/reboot-required ]; then
		echo "${crit}### A reboot is required, you should do it now!${reset}"
	fi
}
