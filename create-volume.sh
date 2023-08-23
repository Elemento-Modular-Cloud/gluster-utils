#! /bin/bash
set -e

NAME="$1"
OPTIONS='replica 3'
TRANSPORT='tcp'
TARGET_PATH='/mnt/raid1/gluster'
HOSTNAME=$(/usr/bin/hostname)
declare -a SERVERS=("zima1.elementohq" "zima2.elementohq" "zima3.elementohq")

SERVERS_STRING=""
for i in "${SERVERS[@]}"
do
   echo
   echo "Working on $i"
   if [ $i == $HOSTNAME ]
   then
      echo "$i is localhost"
      echo "Creating target directory"
      sudo mkdir -p "$TARGET_PATH"
   else
      if [ "`ping -c 1 $i`" ]
      then
        echo "$i is pingable"
      else
        echo "$i is unreachable. Aborting."
        exit 1
      fi
      echo "Creating target directory"
      ssh $USER@$i -t "sudo mkdir -p $TARGET_PATH"
   fi
   SERVERS_STRING="$SERVERS_STRING $i$TARGET_PATH"
   echo
done

echo
echo "Creating gluster volume"
GLUSTER_CMD="sudo gluster volume create $NAME $OPTIONS transport $TRANSPORT $SERVERS_STRING"
echo "Command to be executed:"
echo "   $GLUSTER_CMD"

# "$GLUSTER_CMD"

exit 0
