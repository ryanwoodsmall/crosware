#!/usr/bin/env bash
#
# bind mount a file over /etc/profile.env so ${PATH} works in SSH
#
set -euo pipefail

# ${PATH} to append - we'll need these, probably don't muck
: ${PROFENVPATH:="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"}
: ${PROFENVROOTPATH:="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"}

# privilege escalation command, just call it sudo but setuid doas should work
: ${sudocmd:="sudo"}

# fixup ${PATH} first thing
export PATH="${PATH}:${PROFENVPATH}"

# do not run as root
test "$(id -u)" -eq 0 && {
  printf 'please do not run as root\n' 1>&2
  exit 1
} || true

# std vars
profenv="/etc/profile.env"
cwtop="/usr/local/crosware"
cwtmp="${cwtop}/tmp"
cwprofenv="${cwtmp}/etc_$(basename -- ${profenv})"

# check if we already have a mount
mount | grep -q " ${profenv} " && {
  printf '%s is already mounted\n' "${profenv}" 1>&2
  exit 0
} || true

# make sure we have a dir
mkdir -p "${cwtmp}"
test -e "${cwtmp}" && test -r "${cwtmp}" && test -d "${cwtmp}" || {
  printf '%s not a readable directory\n' "${cwtmp}" 1>&2
  exit 1
}

# insert our ${PATH}
cat "${profenv}" > "${cwprofenv}"
sed -i "/^export PATH=/s,.*,export PATH='/opt/bin:${PROFENVPATH}',g" "${cwprofenv}"
sed -i "/^export ROOTPATH=/s,.*,export ROOTPATH='/opt/bin:${PROFENVROOTPATH}',g" "${cwprofenv}"

# mount it
${sudocmd} $(which mount) -o bind,ro "${cwprofenv}" "${profenv}"
