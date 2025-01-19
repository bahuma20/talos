#!/bin/bash

# Point to the internal API server hostname
APISERVER=https://kubernetes.default.svc

# Path to ServiceAccount token
SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount

# Read the ServiceAccount bearer token
TOKEN=$(cat ${SERVICEACCOUNT}/token)

# Reference the internal certificate authority (CA)
CACERT=${SERVICEACCOUNT}/ca.crt

start_server() {
  echo "[APP] Starting server"
  curl --cacert ${CACERT} \
    --header "Authorization: Bearer ${TOKEN}" \
    --header 'Content-Type: application/strategic-merge-patch+json' \
    --request PATCH \
    ${APISERVER}/apis/apps/v1/namespaces/"${APP_NAMESPACE}"/statefulsets/"${APP_STATEFULSET_NAME}" \
    -d '{"spec":{"replicas":1}}' > /dev/null 2>&1
}

stop_server() {
  echo "[APP] Stopping server"
  curl --cacert ${CACERT} \
    --header "Authorization: Bearer ${TOKEN}" \
    --header 'Content-Type: application/strategic-merge-patch+json' \
    --request PATCH \
    ${APISERVER}/apis/apps/v1/namespaces/"${APP_NAMESPACE}"/statefulsets/"${APP_STATEFULSET_NAME}" \
    -d '{"spec":{"replicas":0}}' > /dev/null 2>&1
}

get_replicas_count() {
  curl --cacert ${CACERT} \
    --header "Authorization: Bearer ${TOKEN}" \
    --request GET \
    ${APISERVER}/apis/apps/v1/namespaces/"${APP_NAMESPACE}"/statefulsets/"${APP_STATEFULSET_NAME}" | jq ".status.replicas"
}


term() {
  echo "[APP] Term received"
  stop_server
}


trap term TERM INT

start_server

sleep 5

replicas=1

while [[ $replicas -ne 0 ]]; do
  replicas=$(get_replicas_count)

  echo "[APP] Aktuell $replicas replicas"

  sleep 5
done

#trap - TERM INT

while [[ $replicas -ne 0 ]]; do
  replicas=$(get_replicas_count)

  echo "[APP] Aktuell $replicas replicas (zweiter loop)"

  sleep 5
done
