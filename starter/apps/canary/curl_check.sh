#!/bin/bash
#how to use the env in the container?
kubectl run debug --env=COUNTER=0 --rm -i --tty --image nicolaka/netshoot -- /bin/bash COUNTER=0; while [  $COUNTER -lt 10 ]; do curl canary-svc; let COUNTER=COUNTER+1; done