#!/usr/bin/env bash

echo
for i in {1..4}
do
    jboss-eap-7.0/bin/jboss-cli.sh -c \
        --command="/host=master/server-config=hacep-$i:read-attribute(name=status)"
done | grep 'STARTED' | wc -l | xargs echo -n "Started "
echo " out of 4 servers."
echo

