#!/usr/bin/env bash

. $(dirname $0)/demo.conf

PUSHD $WORKDIR
    echo

    if [ -d "$JBOSS_HOME" -o -d "$AMQ_HOME" ]
    then
        echo "HACEP currently installed.  Remove it to before re-installing."
        echo
        exit 1
    fi

    echo -n "Install AMQ ................ "
    unzip -q $BINDIR/jboss-a-mq-$VER_DIST_AMQ.zip
    ISOK

    echo -n "Enable AMQ admin user ...... "
    sed -i.bak 's/#\(admin=admin,admin\)/\1/g' $AMQ_HOME/etc/users.properties
    ISOK

    echo -n "Extract activemq-rar.rar ... "
    mkdir tmp
    unzip -q $AMQ_HOME/extras/apache-activemq-$VER_AMQ_RAR-bin.zip -d tmp && \
        cp tmp/apache-activemq-$VER_AMQ_RAR/lib/optional/activemq-rar-$VER_AMQ_RAR.rar . && rm -fr tmp
    ISOK

    echo -n "Install EAP ................ "
    unzip -q $BINDIR/jboss-eap-$VER_DIST_EAP.zip
    ISOK

    if [ -n "$VER_PATCH_EAP" ]
    then
        echo -n "Patch EAP .................. "
        $JBOSS_HOME/bin/jboss-cli.sh \
            --command="patch apply --override-all ${BINDIR}/jboss-eap-${VER_PATCH_EAP}-patch.zip" \
            &> /dev/null
        ISOK
    fi

    echo -n "Setting admin password ..... "
    ${JBOSS_HOME}/bin/add-user.sh -p "${ADMIN_PASS}" -u "${ADMIN_USER}" --silent
    ISOK

    echo -n "Clone the hacep source ..... "
    git clone https://github.com/rlucente-se-jboss/hacep.git -b dco-hacep &> /dev/null
    ISOK

    PUSHD hacep
        echo -n "Build the hacep project .... "
        mvn -Djava.net.preferIPv4Stack=true -Djgroups.bind_addr=localhost \
            clean install -DskipTests &> /dev/null
        ISOK
    POPD

    echo -n "Stage the hacep war file ... "
    cp $HOME/.m2/repository/it/redhat/jdg/examples/hacep-eap-playground/1.0-SNAPSHOT/hacep-eap-playground-1.0-SNAPSHOT.war .
    ISOK

    echo -n "Create config CLI script ... "
cat > $WORKDIR/config.cli <<END1
embed-host-controller

/profile=full:clone(to-profile=hacep-full)

/server-group=hacep:add(socket-binding-group=full-sockets, profile=hacep-full)

/host=master/server-config=hacep-1:add(group=hacep,socket-binding-port-offset=400,auto-start=true)
/host=master/server-config=hacep-2:add(group=hacep,socket-binding-port-offset=500,auto-start=true)

/host=master/server-config=server-one:remove
/host=master/server-config=server-two:remove
/host=master/server-config=server-three:remove

deploy ${WORKDIR}/activemq-rar-${VER_AMQ_RAR}.rar --name=activemq-rar.rar --server-groups=hacep

/server-group=hacep/system-property=org.apache.activemq.SERIALIZABLE_PACKAGES:add(value="*")

/server-group=hacep/jvm=default:add(heap-size=2G,max-heap-size=2G)

/profile=hacep-full/subsystem=resource-adapters/resource-adapter=activemq-rar.rar:add(archive="activemq-rar.rar", transaction-support=XATransaction)
/profile=hacep-full/subsystem=resource-adapters/resource-adapter=activemq-rar.rar/config-properties=UserName:add(value="admin")
/profile=hacep-full/subsystem=resource-adapters/resource-adapter=activemq-rar.rar/config-properties=Password:add(value="admin")
/profile=hacep-full/subsystem=resource-adapters/resource-adapter=activemq-rar.rar/config-properties=ServerUrl:add(value="tcp://localhost:61616?jms.rmIdFromConnectionId=true")
/profile=hacep-full/subsystem=resource-adapters/resource-adapter=activemq-rar.rar/connection-definitions=ConnectionFactory:add(class-name="org.apache.activemq.ra.ActiveMQManagedConnectionFactory", jndi-name="java:/HACEPConnectionFactory", enabled=true, min-pool-size=1, max-pool-size=20, pool-prefill=false, same-rm-override=false, recovery-username="admin", recovery-password="admin", recovery-plugin-class-name="org.jboss.jca.core.recovery.ConfigurableRecoveryPlugin", recovery-plugin-properties={"EnableIsValid" => "false","IsValidOverride" => "true"})

deploy $WORKDIR/hacep-eap-playground-1.0-SNAPSHOT.war --server-groups=hacep

stop-embedded-host-controller
END1
    ISOK

    echo -n "Configure EAP for AMQ ...... "
    $JBOSS_HOME/bin/jboss-cli.sh --file=$WORKDIR/config.cli &> /dev/null && \
        rm -f $WORKDIR/config.cli
    ISOK
   
    echo "Done."
    echo
POPD

