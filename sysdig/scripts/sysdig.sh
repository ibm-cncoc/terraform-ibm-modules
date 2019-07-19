#!/usr/bin/env bash

echo "kubeconfig path:${CONFIG}"
export KUBECONFIG=${CONFIG}
curl -sL https://raw.githubusercontent.com/draios/sysdig-cloud-scripts/master/agent_deploy/IBMCloud-Kubernetes-Service/install-agent-k8s.sh | bash -s -- -a ${ACCESS_KEY} -c ${INGESTION_ENDPOINT} -t terraform:test -t owner:user -ac 'sysdig_capture_enabled: false' -ns ${NAMESPACE}
