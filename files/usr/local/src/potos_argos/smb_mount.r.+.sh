#!/usr/bin/bash

echo "edit me"
exit 0 

mountconfig=example

MOUNT="mount_smb_sudo -s $mountconfig -q -m"
UMOUNT="mount_smb_sudo -s $mountconfig -q -u"
COUNT="mount_smb_sudo -s $mountconfig -q -c"
VERIFY="mount_smb_sudo -s $mountconfig -q -v"

count=$($COUNT)
echo -n "${mountconfig}: "
if [[ $count -eq 0 ]]
then
  echo -n "$count"
else
  if $VERIFY > /dev/null
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