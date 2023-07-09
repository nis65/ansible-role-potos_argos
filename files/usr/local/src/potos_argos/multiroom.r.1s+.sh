#!/usr/bin/bash

HOST=yourmpdsnaphost

MPC="mpc -h $HOST"
SNAPCLIENT="snapclient -h $HOST"

if ping -c 1 -W 0.2 $HOST > /dev/null 2>&1
then
  NET=ok
else
  NET=notok
fi

if [[ "${NET}" == "ok" ]]
then

  FIRSTLINE=$( $MPC status | tr -d "&*" | head -1 )
  PLAYLINE=$( $MPC status | grep playing )
  LASTLINE=$( $MPC status | tr -d "&*" | tail -1 )
  
  echo mpd
  echo ---
  if [[ ! -z "${PLAYLINE}" ]]
  then
    echo $FIRSTLINE
  fi
  echo ---
  for i in pause play stop next prev
  do
    echo "$i | terminal=false bash='$MPC $i'"
  done
  echo ---
  echo "snapweb http://$HOST:1780 | terminal=false bash='sensible-browser http://$HOST:1780/'"
  echo "$SNAPCLIENT | terminal=true bash='killall snapclient; sleep 1; $SNAPCLIENT'" 
  echo "sonata | terminal=false bash=sonata"
  echo ---
  if [[ ! -z "${PLAYLINE}" ]]
  then
    echo $PLAYLINE
    echo $LASTLINE
  fi
else
  echo "mpd offline"
fi
