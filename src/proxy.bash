#!/usr/bin/env bash

pid=$(ps -wef | grep -w 7777 | grep -v grep | awk '{print $2}' | xargs)
if [ ! -z "$pid" ]; then
  echo "there is existing process with pid $pid, trying to terminate it firstly"
  kill -9 $pid
fi

_hostname="localhost"
[ -f ~/xp.log ] && rm -f ~/xp.log
ssh -fNnD 127.0.0.1:7777 -E ~/xp.log root@${_hostname}
[[ $? -ne 0 ]] && echo "the connection to ${_hostname} is not success" && exit -1
pid=$(ps -wef | grep -w 7777 | grep -v grep | awk '{print $2}' | xargs)
[[ -n $pid ]] && echo "new proxy started with pid $pid" || echo "no proxy established"

