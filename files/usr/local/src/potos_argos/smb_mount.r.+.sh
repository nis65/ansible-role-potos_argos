#!/usr/bin/bash

DISPLAYNAME=changeme
SMBUSER=yoursmbuser
SMBHOST=yoursmbhost
SMBDOMAIN=yoursmbdomain
HOMEBASE=$DISPLAYNAME

MOUNT="mount_smb_sudo -s $SMBHOST -d $SMBDOMAIN -b $HOMEBASE -n $SMBUSER -q -m"
UMOUNT="mount_smb_sudo -s $SMBHOST -d $SMBDOMAIN -b $HOMEBASE -n $SMBUSER -q -u"
COUNT="mount_smb_sudo -s $SMBHOST -d $SMBDOMAIN -b $HOMEBASE -n $SMBUSER -q -c"
VERIFY="mount_smb_sudo -s $SMBHOST -d $SMBDOMAIN -b $HOMEBASE -n $SMBUSER -v"

count=$($COUNT)
echo -n "${DISPLAYNAME}: "
if [[ $count -eq 0 ]]
then
  echo -n "$count"
else
  if $VERIFY -t 3 -q > /dev/null
  then
    echo -n "$count"
  else
    echo -n "($count)"
  fi
fi
echo ""
echo "---"
echo "mount | terminal=true bash='$MOUNT; sleep 4; exit'"
echo "umount | terminal=false bash='$UMOUNT'"
echo "force umount | terminal=true bash='$UMOUNT -y'; sleep 4; exit"
echo "verify | terminal=true bash='$VERIFY -t 20'"
