#!/bin/bash

test -z "${CROS_USER_ID_HASH}" && {
  echo "CROS_USER_ID_HASH not set"
  exit 1
}

vsh \
  --vm_name=termina \
  --owner_id="${CROS_USER_ID_HASH}" \
    -- \
    "${@}"
