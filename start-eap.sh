#!/usr/bin/env bash

. $(dirname $0)/demo.conf

PUSHD $WORKDIR
    ./jboss-eap-${VER_INST_EAP}/bin/domain.sh
POPD

