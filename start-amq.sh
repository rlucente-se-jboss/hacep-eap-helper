#!/usr/bin/env bash

. $(dirname $0)/demo.conf

PUSHD $WORKDIR
    # /dev/./urandom because of https://bugs.java.com/view_bug.do?bug_id=6202721
    ./jboss-a-mq-$VER_DIST_AMQ/bin/amq -Djava.security.egd=file:/dev/./urandom
POPD

