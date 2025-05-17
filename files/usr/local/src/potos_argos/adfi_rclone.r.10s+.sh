#!/usr/bin/bash

BINARY=adfinis-rclone-mount
ABSBINARY=$( which $BINARY )

URL="https://github.com/adfinis/adfinis-rclone-mount/releases"

if [[ ! -x $ABSBINARY ]]
then
  echo "rclone: not installed"
  echo "---"
  echo "$URL | terminal=true bash='echo $URL; read a; exit'"
  exit
fi

CONFIGURE="$ABSBINARY"
MOUNTALL="$ABSBINARY mount all"
UMOUNTALL="$ABSBINARY umount all"
STATUS="$ABSBINARY ls"

JSONSTATUS=$( $STATUS --json )

MOUNTED=$( echo $JSONSTATUS | jq '.[] | select(.Status=="active") | .Name')
MOUNTCOUNT=$( echo $JSONSTATUS | jq '.[] | select(.Status=="active")' | jq -s '. | length')
NOTMOUNTED=$( echo $JSONSTATUS | jq '.[] | select(.Status!="active") | "\(.Status) -- \(.Name)"' | sort)
NOTMOUNTCOUNT=$( echo $JSONSTATUS | jq '.[] | select(.Status!="active")' | jq -s '. | length')
TOTALCOUNT=$(( MOUNTCOUNT + NOTMOUNTCOUNT ))

if [[ $TOTALCOUNT -eq 0 ]]
then
  echo "rclone: unconfigured"
  echo "---"
  echo "configure | terminal=false bash='gnome-terminal --window --geometry 100x40 --title \"configuring, press enter when done\" -- bash -c \"$CONFIGURE; read a\"'"
else
  echo "rclone: $MOUNTCOUNT of $TOTALCOUNT"
  echo "---"
  if [[ $MOUNTCOUNT -lt $TOTALCOUNT ]]
  then
    echo "mount all | terminal=false bash='gnome-terminal --window --geometry 100x$(( $TOTALCOUNT + 6 )) --title \"press enter to close\" -- bash -c \"$MOUNTALL; read a\"'"
  else
    echo "(mount all)"
  fi
  if [[ "$MOUNTCOUNT" -gt 0 ]]
  then
    echo "umount all | terminal=false bash='gnome-terminal --window --geometry 100x$(( $TOTALCOUNT + 6 )) --title \"press enter to close\" -- bash -c \"$UMOUNTALL; read a\"'"
  else
    echo "(umount all)"
  fi
  if [[ $MOUNTCOUNT -eq $TOTALCOUNT ]]
  then 
    echo -n "state (all mounted)"
  else
    echo -n "state (not mounted: $NOTMOUNTCOUNT)"
  fi
  echo "| terminal=false bash='gnome-terminal --window --geometry 100x$(( $TOTALCOUNT + 6 )) --title \"press enter to close\" -- bash -c \"$STATUS; read a\"'"
fi
