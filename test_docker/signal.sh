#!/bin/bash

echo "Script started with $@"
ps

handler() {
 echo "Handler run with $@"
 exit
}

trap handler SIGHUP SIGINT SIGTERM SIGQUIT
while true;
do
 sleep 1;
done
