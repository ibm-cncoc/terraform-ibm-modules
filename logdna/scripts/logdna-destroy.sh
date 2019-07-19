#!/usr/bin/env bash
export KUBECONFIG=${CONFIG}
# Changing context to namespace default. Logdna agent is installed in 'default' namepsace
kubectl config set-context $(kubectl config current-context) --namespace=default
kubectl delete secret logdna-agent-key 
kubectl delete -f https://repo.logdna.com/ibm/prod/logdna-agent-ds-us-south.yaml
