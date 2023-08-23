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
   if [ $i == $HOSTNAME ]
   then
      echo "$i is localhost"
      sudo mkdir -p "$TARGET_PATH"
   else
      if [ "`ping -c 1 $i`" ]
      then
        echo "$i is available"
      else
        echo "$i is unreachable. Aborting."
        exit 1
      fi
      ssh $USER@$i -t "sudo mkdir -p $TARGET_PATH"
   fi
   SERVERS_STRING="$SERVERS_STRING $i$TARGET_PATH"
done

GLUSTER_CMD="sudo gluster volume create $NAME $OPTIONS transport $TRANSPORT $SERVERS_STRING"

# "$GLUSTER_CMD"

exit 0
