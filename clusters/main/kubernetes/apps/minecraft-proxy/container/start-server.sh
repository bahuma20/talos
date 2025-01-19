#!/bin/bash

# Point to the internal API server hostname
APISERVER=https://kubernetes.default.svc

# Path to ServiceAccount token
SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount

# Read the ServiceAccount bearer token
TOKEN=$(cat ${SERVICEACCOUNT}/token)

# Reference the internal certificate authority (CA)
CACERT=${SERVICEACCOUNT}/ca.crt

# Start server
start() {
  curl --cacert ${CACERT} \
    --header "Authorization: Bearer ${TOKEN}" \
    --header 'Content-Type: application/strategic-merge-patch+json' \
    --request PATCH \
    ${APISERVER}/apis/apps/v1/namespaces/"${APP_NAMESPACE}"/statefulsets/"${APP_STATEFULSET_NAME}" \
    -d '{"spec":{"replicas":1}}' > /dev/null 2>&1
}

stop() {
    curl --cacert ${CACERT} \
      --header "Authorization: Bearer ${TOKEN}" \
      --header 'Content-Type: application/strategic-merge-patch+json' \
      --request PATCH \
      ${APISERVER}/apis/apps/v1/namespaces/"${APP_NAMESPACE}"/statefulsets/"${APP_STATEFULSET_NAME}" \
      -d '{"spec":{"replicas":0}}' > /dev/null 2>&1
}

is_running() {
      curl --cacert ${CACERT} \
        --header "Authorization: Bearer ${TOKEN}" \
        --header 'Content-Type: application/strategic-merge-patch+json' \
        --request GET \
        ${APISERVER}/apis/apps/v1/namespaces/"${APP_NAMESPACE}"/statefulsets/"${APP_STATEFULSET_NAME}" \
        -d '{"spec":{"replicas":0}}' > /dev/null 2>&1
}


