# HACEP EAP Helper
This project provides helper scripts to simplify standing up the
[Highly Available Complex Event Processing](https://github.com/redhat-italy/hacep)
(HACEP) EAP playground application from Red Hat Italy.

## Prepare
Open four command line terminals.  In the first terminal window,
clone this repository:

     git clone https://github.com/rlucente-se-jboss/hacep-eap-helper.git

Within the remaining terminals, change to the directory where you
cloned this repository.

Place all prescribed files in `dist` per the `readme.txt` file
there.  Review the `demo.conf` file and make sure that the versions
match the files in `dist`.

## Install
Once the `dist` directory is populated with the requisite distribution
files and the `demo.conf` file has matching versions, install the
demo:

     ./install.sh

## Start
In the first terminal, start the AMQ message broker:

    ./start-amq.sh

Wait for the AMQ console prompt to appear so that AMQ is fully
started.

In the second terminal, start the EAP servers:

    ./start-eap.sh

Wait until all the servers are running.  You can check this using:

    ./check-eap-status.sh

and make sure that all four servers are started.

## Demo
Open a browser to the HACEP EAP Playground UI at
http://localhost:8480/hacep-playground

In the third terminal, run the test client using

    ./run-perf-client.sh

In the fourth terminal, use the CLI to start/stop individual servers
per [Running the demo](https://github.com/redhat-italy/hacep/tree/master/hacep-examples/hacep-eap-playground#running-the-demo)

For example, to stop server 3:

    ./control-server.sh stop 3

And to restart server 3:

    ./control-server.sh start 3

