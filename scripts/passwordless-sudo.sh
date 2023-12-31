#
# wrap sudo
# create a password-less bind mount sudoers.d file
# should only prompt for password on first use
#
# XXX - realsudo should be overridable e.g. to sudossh/sudossht?
# XXX - utilize doas if sudo not found?
#
function sudo() {
  local realsudo="/usr/bin/sudo"
  local sudoersddir="/etc/sudoers.d"
  local sudoersdfile="95_cros_base"
  local tmpdir="/usr/local/tmp"
  ${realsudo} test -e ${sudoersddir}/${sudoersdfile} && {
    mount | grep -q " ${sudoersddir}/${sudoersdfile} " || {
      echo "bind mounting ${sudoersddir}/${sudoersdfile}" 1>&2
      ${realsudo} mkdir -p ${tmpdir} \
      && ${realsudo} chmod 3775 ${tmpdir} \
      && ${realsudo} chgrp chronos ${tmpdir} \
      && echo 'chronos ALL=(ALL:ALL) NOPASSWD: ALL' | ${realsudo} tee ${tmpdir}/${sudoersdfile} >/dev/null 2>&1 \
      && ${realsudo} chown root:root ${tmpdir}/${sudoersdfile} \
      && ${realsudo} chmod 440 ${tmpdir}/${sudoersdfile} \
      && ${realsudo} mount -o bind ${tmpdir}/${sudoersdfile} ${sudoersddir}/${sudoersdfile}
    }
  }
  ${realsudo} "${@}"
}
