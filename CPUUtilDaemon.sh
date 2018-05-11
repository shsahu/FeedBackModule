#!/bin/sh

NAME="[ CPU Utilization DAEMON ]"
PID="./daemon.pid"
CMD="collectCheckCPUUtil.sh"

start()
{
  if [ -e $PID ]; then
    echo "$NAME already running"
    exit 1
  fi
  echo "$NAME START!"
  ./$CMD $1 $2 $3 &
  echo $! > $PID
}

stop()
{
  if [ ! -e $PID ]; then
    echo "$NAME not running"
    exit 1
  fi
  echo "$NAME STOP!"
  kill -9 "$(cat $PID)"
  rm $PID
}

restart()
{
  stop
  sleep 2
  start $1 $2 $3
}

case "$1" in
  start)
    start $2 $3 $4
    ;;
  stop)
    stop
    ;;
  restart)
    restart $2 $3 $4
    ;;
  *)
    echo "Syntax Error: release [start|stop|restart]"
    ;;
esac
