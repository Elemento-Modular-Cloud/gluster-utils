#! /bin/bash
set -e

NAME="$1"
OPTIONS='replica 3'
TRANSPORT='tcp'
PATH='/mnt/raid1/gluster'
declare -a SERVERS=("zima1.elementohq" "zima2.elementohq" "zima3.elementohq")

SERVERS_STRING=""
for i in "${SERVERS[@]}"
do
   if [ "`ping -c 1 $i`" ]
   then
     echo "$i is available"
   else
     echo "$i is unreachable. Aborting."
     exit 1
   fi
   ssh $USER@$i "mkdir -p $PATH"
   SERVERS_STRING="$SERVERS_STRING $i$PATH"
done

BASE_CMD="gluster volume create $NAME $OPTIONS transport $TRANSPORT $SERVERS_STRING"

sudo "$BASE_CMD"

exit 0
