#! /bin/bash

NAME='datavault'
OPTIONS='replica 3'
TRANSPORT='tcp'
PATH='/mnt/raid1/gluster'
declare -a SERVERS=("zima1.elementohq" "zima2.elementohq" "zima3.elementohq")
SERVERS_STRING=""
for i in "${SERVERS[@]}"
do
   echo "$i"
   SERVERS_STRING="$SERVERS_STRING $i$PATH"
done

echo "$SERVERS_STRING"

BASE_CMD="gluster volume create $NAME $OPTIONS transport $TRANSPORT zima1.elementohq:/mnt/raid1/gluster/datavault zima2.elementohq:/mnt/raid1/gluster/datavault zima3.elementohq:/mnt/raid1/gluster/datavault"
