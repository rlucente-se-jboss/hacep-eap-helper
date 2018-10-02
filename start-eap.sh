#!/usr/bin/env bash

. $(dirname $0)/demo.conf

PUSHD $WORKDIR
    find ./jboss-eap-${VER_INST_EAP} -type f \
        -name '*.log' -exec truncate -s 0 {} \;
    ./jboss-eap-${VER_INST_EAP}/bin/domain.sh
POPD

