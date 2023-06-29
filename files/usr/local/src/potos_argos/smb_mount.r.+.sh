#!/usr/bin/bash

DISPLAYNAME=changeme
SMBUSER=yoursmbuser
SMBHOST=yoursmbhost
SMBDOMAIN=yoursmbdomain
HOMEBASE=$DISPLAYNAME

#VPNNAME=yourvpnname

MOUNT="mount_smb_sudo -s $SMBHOST -d $SMBDOMAIN -b $HOMEBASE -n $SMBUSER -q -m"
UMOUNT="mount_smb_sudo -s $SMBHOST -d $SMBDOMAIN -b $HOMEBASE -n $SMBUSER -q -u"
COUNT="mount_smb_sudo -s $SMBHOST -d $SMBDOMAIN -b $HOMEBASE -n $SMBUSER -q -c"
VERIFY="mount_smb_sudo -s $SMBHOST -d $SMBDOMAIN -b $HOMEBASE -n $SMBUSER -v"


if [[ ! -z "${VPNNAME}" ]]
then
  STARTVPN="nmcli c up ${VPNNAME}"
  STOPVPN="nmcli c down ${VPNNAME}"
  VPNSTATE=$( LANG=C nmcli c show "${VPNNAME}" | sed -ne "s/VPN.VPN-STATE: *//p" )
  if [[ -z "${VPNSTATE}" ]]
  then
    VPNSTATE="X - down"
  elif [[ "${VPNSTATE}" == "5 - VPN connected" ]]
  then
    NETGOOD=yes
  else
    NETGOOD=no
  fi
else
  NETGOOD=yes
fi

# the menu title is composed of
#  $DISPLAYNAME
#  count of mounts from that host
#  if the count is non zero, it is shown as
#     3: when $NETGOOD is yes and $VERIFY successul
#   (3): when $NETGOOD is yes but $VERIFY failed
# ((3)): when $NETGOOD is no (does not happen without VPN)

count=$($COUNT)
echo -n "${DISPLAYNAME}: "
if [[ $count -eq 0 ]]
then
  echo -n "$count"
else
  if [[ "${NETGOOD}" == "yes" ]]
  then
    if $VERIFY -t 3 -q > /dev/null
    then
      echo -n "$count"
    else
      echo -n "($count)"
    fi
  else
    echo -n "(($count))"
  fi
fi
echo ""
echo "---"
echo "mount | terminal=true bash='$MOUNT; sleep 4; exit'"
echo "umount | terminal=false bash='$UMOUNT'"
echo "force umount | terminal=true bash='$UMOUNT -y'; sleep 4; exit"
echo "verify | terminal=true bash='$VERIFY -t 20'"
if [[ ! -z "${VPNNAME}" ]]
then
  echo "---"
  echo "start vpn | terminal=false bash='$STARTVPN'"
  echo "stop vpn | terminal=false bash='$STOPVPN'"
  echo "---"
  echo "VPN state: $VPNSTATE"
fi
