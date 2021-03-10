#!/bin/bash
# Author: Skiqqy
# This script contains functions that I use in my other scripts.
# Note, this script does basic asserts for SOME functions.

# Get input from a user using dmenu, with a displayed prompt.
# Usage: var=$(prompt "some prompt")
prompt () {
	[ ! "$(command -v dmenu)" ] && return 1
	echo "" | dmenu -p "$1"
}
