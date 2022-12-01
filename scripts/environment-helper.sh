#!/bin/bash
#
# XXX - probably needs to be a list of keys?
# - id_rsa
# - id_ecdsa
# - id_ed25519
# - id_xmss
# - id_dsa
#
# probably not since may require physical usb/token/... authorization:
# - id_ecdsa_sk
# - id_ed25519_sk
#

envscript="/tmp/transient-environment.sh"
touch "${envscript}"

# ssh-agent
if ! $(ps -U "${USER}" | grep -q 'ssh-agent') ; then
  eval `ssh-agent -s`
  for e in SSH_AGENT_PID SSH_AUTH_SOCK ; do
    sed -i "/^export ${e}=.*/d" "${envscript}"
    echo "export ${e}=${!e}" >> "${envscript}"
  done
fi
. "${envscript}"

# ssh-add default key
: ${defsshkey:="${HOME}/.ssh/id_rsa"}
if [ -e "${defsshkey}" ] ; then
  ssh-add -q "${defsshkey}"
fi

# chrome/chromium os user id hash
if [ ! -z "${CROS_USER_ID_HASH}" ] ; then
  sed -i "/^export CROS_USER_ID_HASH=.*/d" "${envscript}"
  echo "export CROS_USER_ID_HASH=${CROS_USER_ID_HASH}" >> "${envscript}"
fi
. "${envscript}"
