#!/usr/bin/bash
RANDR=/usr/local/bin/gnome-randr
BUILTIN="eDP-1"

echo "res"
echo "---"
previous="NONE"
$RANDR query $BUILTIN | while read line
do
  RES=$( echo $line | sed -ne "s/^ *\([0-9][0-9]*x[0-9][0-9]*@[0-9.]*\).*/\1/p" )
  if [[ ! -z "$RES" ]]
  then
    short=${RES%@*}
    if [[ "${short}" != "${previous}" ]]
    then
      XX=${short%%x*}
      YY=${short##*x}
      RATIO=$(( $XX * 100 / $YY ))
      FLAGS=$( echo $line | sed -ne "s/^ *\([0-9][0-9]*x[0-9][0-9]*@[0-9.]*\)[^*+]*\([\*\+]*\) .*$/\2/p" )
      if $( echo "$FLAGS" | grep "\+" > /dev/null )
      then
        # mark default setting green
        echo -n "$RATIO <span foreground='green'>$short</span>"
      else
        echo -n "$RATIO $short"
      fi
      echo "$FLAGS | terminal=false bash='$RANDR modify $BUILTIN --mode $RES'"
    fi
    previous=$short
  fi
done | sort -r
