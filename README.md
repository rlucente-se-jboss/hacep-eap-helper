# HACEP EAP Helper
This project provides some scripts to simplify standing up the
[Highly Available Complex Event Processing](https://github.com/redhat-italy/hacep)
(HACEP) EAP playground application from Red Hat Italy.

Open four command line terminals
Clone this repository

     git clone https://github.com/rlucente-se-jboss/hacep-eap-helper.git

Place all prescribed files in `dist` per the `readme.txt` file there.
Make sure that demo.conf is correct and matches file versions in `dist`.
Install the demo

     ./install.sh

In first terminal, start AMQ

    ./jboss-a-mq-6.2.1.redhat-084/bin/amq

Wait for AMQ to fully start

In second terminal, start EAP servers (there should be four)

    ./jboss-eap-7.0/bin/domain.sh

Wait until all four servers are running

The HACEP EAP Playground UI is available at

http://localhost:8180/hacep-playground
http://localhost:8280/hacep-playground
http://localhost:8380/hacep-playground
http://localhost:8480/hacep-playground

In third terminal, run the test client using

    ./run-perf-client.sh

In fourth terminal, use the CLI to start/stop individual servers per [Running the demo](https://github.com/redhat-italy/hacep/tree/master/hacep-examples/hacep-eap-playground#running-the-demo)

For example, to stop server 3 use

    ./jboss-eap-7.0/jboss-cli.sh --connect --command="/host=master/server-config=hacep-3:stop"

And to restart server 3, use

    ./jboss-eap-7.0/jboss-cli.sh --connect --command="/host=master/server-config=hacep-3:start"

