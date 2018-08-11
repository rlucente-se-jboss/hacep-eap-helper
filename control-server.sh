#!/usr/bin/env bash

. $(dirname $0)/demo.conf

SCRIPT=$(basename $0)

function usage {
  echo "./$SCRIPT start|stop 1|2|3|4"
}

PUSHD $WORKDIR

  if [ "$#" -ne 2 ]
  then
    usage
    exit 1
  fi

  case "$1" in
    start)
      CMD="start"
      ;;
    stop)
      CMD="stop"
      ;;
    *)
      usage
      ;; 
  esac

  SERVER=$2

  if [ "$2" -lt 1 -o "$2" -gt 4 ]
  then
    usage
    exit 1
  fi
  
  ./jboss-eap-${VER_INST_EAP}/bin/jboss-cli.sh --connect \
      --command="/host=master/server-config=hacep-${SERVER}:${CMD}"
POPD

