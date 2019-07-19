#!/usr/bin/env bash
export KUBECONFIG=${CONFIG}
echo "kubeconfig path:${CONFIG}"
curl -sL https://raw.githubusercontent.com/draios/sysdig-cloud-scripts/master/agent_deploy/IBMCloud-Kubernetes-Service/install-agent-k8s.sh | bash -s -- -r -ns ${NAMESPACE}
kubectl delete ns ${NAMESPACE}