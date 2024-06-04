#!/usr/bin/env bash
#
# use lsof to get a list of arcvm (android vm) files open on the chromeos host
# XXX - needs sudossh and root-level sshd server setup; see:
#     - scripts/start-root-sshd
#     - scripts/usr-local-bin-sudossh
# XXX - generalize with option/environment var for termina as well?
#
set -euo pipefail
pids="$(for p in $(sudossh $(which pgrep) crosvm) ; do tr \\0 \\n < <(sudossh cat /proc/${p}/{cmdline,environ}) | grep -qi arc && echo $p ; done) | sed 's,^.*(,,g;s,)$,,g' | sort -un | paste -s -d, -)"
sudossh lsof -P -n -l -p $(sudossh $(which pstree) -p "${pids}"
