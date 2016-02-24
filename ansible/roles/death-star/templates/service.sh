#! /bin/bash

. /etc/init.d/functions
set -u

# Service settings
SERVICE_NAME="death-star"
SERVICE_USER="death-star"
PID_FILE="/var/run/$SERVICE_NAME.pid"
LOCK_FILE="/var/lock/subsys/$SERVICE_NAME"
LOG_FILE="/var/log/$SERVICE_NAME/$SERVICE_NAME.log"
ERRLOG_FILE="/var/log/$SERVICE_NAME/$SERVICE_NAME-error.log"

# Directories & Files
APP_DIR="{{ delivery_directory }}/current"
JAR_PATH="$APP_DIR/back/death-star-automation.jar"
FRONT_LOCATION="file://$APP_DIR/front"

# Java arguments & command
JAVA_COMMAND="/usr/bin/java -jar $JAR_PATH $FRONT_LOCATION"

fail() {
  failure
  echo
  exit 1
}

start() {

  echo -n "Starting death-star: "

  [ $EUID = 0 ] || {
    echo -n "This script must be run as root"
    fail
  }

  [ -s $PID_FILE ] && {
    echo -n "already running... pid: `cat $PID_FILE`"
    fail
  }

  /usr/local/sbin/daemonize -u $SERVICE_USER -p $PID_FILE -o $LOG_FILE -e $ERRLOG_FILE -c $APP_DIR $JAVA_COMMAND && {
    touch $LOCK_FILE
    success
    echo
  } || {
    fail
  }

}

stopFailed() {
  # Delete PID_FILE & LOCK FILE
  rm -f $PID_FILE
  rm -f $LOCK_FILE

  failure
}

stop() {

  echo -n "Stopping death-star: "

  [ $EUID = 0 ] || {
    echo -n "This script must be run as root"
    fail
  }

  [ -f "$PID_FILE" ] || {
    echo -n "already stopped ..."
    stopFailed
    return
  }

  PID=`cat $PID_FILE`

  [ -n $PID ] || {
    echo -n "already stopped ..."
    stopFailed
    return
  }

  kill -15 $PID || {
    echo -n "already stopped ..."
    stopFailed
    return
  }

  # Wait for the application to stop
  while [ `ps -p $PID > /dev/null` ]
  do
      sleep 1
  done

  sleep 5

  # Delete PID_FILE & LOCK FILE
  rm -f $PID_FILE
  rm -f $LOCK_FILE

  success

}

status() {
  [ -s $PID_FILE ] && {
    exit 0
  } || {
    exit 1
  }
}

printHelp() {
  echo "Usage: {start|stop|restart}"
  exit 2
}

case "$1" in
    start)
      start
      ;;
    stop)
      stop
      ;;
    restart)
      stop
      start
      ;;
    status)
      status
      ;;
    *)
      printHelp
      ;;
esac