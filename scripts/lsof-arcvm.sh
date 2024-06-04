#!/usr/bin/env bash
#
# use lsof to get a list of arcvm (android vm) files open on the chromeos host
# XXX - needs sudossh and root-level sshd server setup; see:
#     - scripts/start-root-sshd
#     - scripts/usr-local-bin-sudossh
# XXX - generalize with option/environment var for termina as well?
# XXX - pipefail... come on man
# XXX - okay fuck this it doesn't work
#
set -o pipefail
##set -eu
#: ${sshkey:="${HOME}/.ssh/id_rsa"}
#: ${sudocmd:="sudossh -i ${sshkey}"}
#arcvmpid="$(for p in $(pgrep crosvm) ; do tr '\0' '\n' < <(${sudocmd} cat /proc/${p}/{cmdline,environ} || true) | grep -qi arcvm && echo $p || true ; done | head -1)"
#echo godd
##pids="$(${sudocmd} $(which pstree) -p ${arcvmpid} | sed 's,^.*(,,g;s,)$,,g' | sort -un | paste -s -d, -)"
##${sudocmd} $(which lsof) -P -n -l -p "${pids}"
#echo what 

sudossh lsof -P -n -l -p $(sudossh $(which pstree) -p $(for p in $(sudossh $(which pgrep) crosvm) ; do tr \\0 \\n < <(sudossh cat /proc/${p}/{cmdline,environ}) | grep -qi arc && echo $p ; done) | sed 's,^.*(,,g;s,)$,,g' | sort -un | paste -s -d, -)
