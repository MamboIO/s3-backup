#!/bin/sh -l
set -euo pipefail

STORAGE_SERVICE_ALIAS=${STORAGE_SERVICE_ALIAS:="s3"}
STORAGE_SERVICE_URL=${STORAGE_SERVICE_URL:="https://s3.amazonaws.com"}
SESSION_TOKEN=${SESSION_TOKEN:=""}
MIRROR_SOURCE=${MIRROR_SOURCE:="."}
REGION=${REGION:=""}

# Set mc configuration
if [ -z "$SESSION_TOKEN" ]; then
  mc alias set "$STORAGE_SERVICE_ALIAS" "$STORAGE_SERVICE_URL" "$ACCESS_KEY_ID" "$SECRET_ACCESS_KEY"
  # Execute mc mirror
  mc mirror $* "$MIRROR_SOURCE" "$STORAGE_SERVICE_ALIAS/$MIRROR_TARGET"
else
  export MC_HOST_${STORAGE_SERVICE_ALIAS}=https://${ACCESS_KEY_ID}:${SECRET_ACCESS_KEY}:${SESSION_TOKEN}@s3.${REGION}.amazonaws.com
  # Execute mc mirror
  mc mirror $* "$MIRROR_SOURCE" "$STORAGE_SERVICE_ALIAS/$MIRROR_TARGET"
fi

