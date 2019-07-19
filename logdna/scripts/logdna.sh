#!/usr/bin/env bash
export KUBECONFIG=${CONFIG}
# Changing context to namespace default. Logdna agent will be installed in 'default' namepsace
kubectl config set-context $(kubectl config current-context) --namespace=default
kubectl create secret generic logdna-agent-key --from-literal=logdna-agent-key=${SERVICE_KEY}
kubectl create -f https://repo.logdna.com/ibm/prod/logdna-agent-ds-us-south.yaml
