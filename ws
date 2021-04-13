#!/bin/bash
# Simple tmux work session builder/launcher
# Written by skiqqy

argv=( "$@" )

usage ()
{
	cat << EOF
ws ~ skiqqy's tmux workspace

Usage: ws [options] WINDOW-NAME

options
-------

-h         Shows this message.
-s NAME    Specify the session name.
-a         Attach to the session.
EOF
	exit "$1"
}

# Build my tmux workspace
# Usage: build "session:pain"
build ()
{
	tmux split-window -t "$1" -h -p 50
	tmux send-keys -t "$1.0" 'ranger' Enter
	tmux send-keys -t "$1.1" '' Enter
}

main ()
{
	opts='hs:a'
	sesh=PW
	attach=false

	# Get the session name, whilst checking it was actually passed
	[ "$#" -eq 0 ] && usage 1
	wn=$(sed -E 's|(-s .+ )\|(-.* )||g' <<< "$@")
	if [[ $wn =~ ^- ]]
	then
		# Last argument is a parameter, hence WINDOW-NAME was not passed
		usage 1
	fi

	while getopts "$opts" opt
	do
		case "$opt" in
			h)
				usage 0
				;;
			s)
				sesh="$OPTARG"
				;;
			a)
				attach=true
				;;
			*)
				usage 1
				;;
		esac
	done

	if tmux has-session -t "$sesh:$wn" > /dev/null 2>&1
	then
		# Session exists, attach
		echo "$sesh:$wn already exists, skipping."
	elif tmux has-session -t "$sesh" > /dev/null 2>&1
	then
		echo "Creating window."
		tmux a -t -d "$sesh" > /dev/null 2>&1
		tmux new-window -d -n "$wn"
		build "$sesh:$wn"
	else
		echo "Session DNE, creating $sesh:$wn"
		tmux new-session -d -s "$sesh"
		tmux rename-window -t "$sesh:1" "$wn"
		build "$sesh:$wn"
	fi

	if "$attach"
	then
		tmux a -t "$sesh:$wn"
	fi
}

main "$@"
