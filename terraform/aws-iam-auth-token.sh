#!/bin/sh
set -euo pipefail

eval "$(jq -r '@sh "CLUSTER_NAME=\(.cluster_name)"')"
TOKEN=$(aws-iam-authenticator token -i $CLUSTER_NAME | jq -r .status.token)
jq -n --arg token "$TOKEN" '{"token": $token}'