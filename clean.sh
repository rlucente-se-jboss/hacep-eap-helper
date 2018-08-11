#!/usr/bin/env bash

. $(dirname $0)/demo.conf

PUSHD $WORKDIR
    rm -fr jboss-eap-* jboss-a-mq-* activemq-rar*.rar hacep*
POPD

