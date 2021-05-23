#!/bin/bash

flag=$1

if [ -z $flag ]
then
  echo "Some parameter value is empty. Usage: hadoop-start.sh <flag [ start | restart ]>"
  exit 1
fi

if [ $flag != "start" ] && [ $flag != "restart" ] ; then
  echo "Wrong flag detected. Available flag is [ start | restart ]"
  exit 1
fi

echo "Start Hadoop service."
if [ $flag = "restart" ]
then
  docker exec -it master bash -c "/sh/restart-all.sh"
elif [ $flag = "start" ]
then
  docker exec -it master bash -c "/sh/start-all.sh"
fi