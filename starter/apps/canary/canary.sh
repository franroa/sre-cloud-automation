#!/bin/bash

DEPLOY_INCREMENTS=2

function canary_deploy {
  NUM_OF_V1_PODS=$(kubectl get pods -n udacity | grep -c canary-v1)
  echo "V1 PODS: $NUM_OF_V1_PODS - Scaling down to 2"
  NUM_OF_V2_PODS=$(kubectl get pods -n udacity | grep -c canary-v2)
  echo "V2 PODS: $NUM_OF_V2_PODS - Scaling up to 2"

  kubectl scale deployment canary-v2 --replicas=$((NUM_OF_V2_PODS + $DEPLOY_INCREMENTS))
  kubectl scale deployment canary-v1 --replicas=$((NUM_OF_V1_PODS - $DEPLOY_INCREMENTS))
  # Check deployment rollout status every 1 second until complete.
  ATTEMPTS=0
  ROLLOUT_STATUS_CMD="kubectl rollout status deployment/canary-v2 -n udacity"
  until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
    $ROLLOUT_STATUS_CMD
    ATTEMPTS=$((attempts + 1))
    sleep 1
  done
  echo "Canary deployment of $DEPLOY_INCREMENTS replicas successful!"
}

# Initialize canary-v2 deployment
kubectl apply -f canary-v2.yml
kubectl apply -f index_v2_html.yml
canary_deploy
