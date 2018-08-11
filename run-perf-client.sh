#!/usr/bin/env bash

. $(dirname $0)/demo.conf

PUSHD $WORKDIR

cd hacep/hacep-examples/hacep-perf-client    
mvn exec:java -Dduration=480 -Dconcurrent.players=20 -Ddelay.range=5 \
    -Devent.interval=1 -Dtest.preload=true -Dtest.messages=10 \
    -Dbroker.host="localhost:61616" -Dbroker.authentication=true \
    -Dbroker.usr=admin -Dbroker.pwd=admin \
    -Dorg.apache.activemq.SERIALIZABLE_PACKAGES="*"

POPD

