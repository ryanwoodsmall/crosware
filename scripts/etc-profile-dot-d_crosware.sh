#!/usr/bin/env bash
#
# add crosware to the environment, safely-ish, for non-root users
# copy/symlink to e.g. /etc/profile.d/zz-local.sh or similar
# add some common paths, just in case
#
# XXX - custom GIT_SSH_COMMAND for dropbear if ${CW_GIT_CMD} is git?
# XXX - TERM/EDITOR/USER/UID/etc. defaults?
#
if [ ! -z "${BASH_VERSION}" ] ; then
  if [ "${UID}" -ne 0 ] ; then
    export PATH="${PATH}:/usr/local/sbin"
    export PATH="${PATH}:/usr/sbin"
    export PATH="${PATH}:/sbin"
    export CW_GIT_CMD=git
    . /usr/local/crosware/etc/profile &>/dev/null || true
  fi
fi
# vim: ft=bash
