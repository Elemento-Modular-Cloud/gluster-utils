#! /bin/bash
set -e

if [ -z "$1" ]
then
  echo "Please specify Volume Name as first argument"
fi

if [ -z "$2" ]
then
  echo "Please specify Gluster options as second argument (e.g. 'replica 3')"
fi

if [ -z "$3" ]
then
  echo "Please specify Gluster transport as third argument (e.g. 'tcp')"
fi

if [ -z "$4" ]
then
  echo "Please specify target path as fourth argument"
fi

NAME="$1"
OPTIONS="$2"
TRANSPORT="$3"
TARGET_PATH='/mnt/raid1/gluster'
HOSTNAME=$(/usr/bin/hostname)

shift 4

declare -a SERVERS=("$@")

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
echo "$GLUSTER_CMD"

# "$GLUSTER_CMD"

exit 0
