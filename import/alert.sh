#!/bin/bash
# Author: Skiqqy
# Simple error message script used by my other scripts
# USAGE: error "message" <exit_code>
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Display an error message and exit.
# error [message] [exit code]
error () {
	printf "[${RED}ERROR${NC}] $1\n"
	exit $2
}

warning () {
	printf "[${YELLOW}WARNING${NC}] $1\n"
}
