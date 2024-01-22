#!/usr/bin/env bash
#
# grabs pci.ids, usb.ids from upstream into ${cwetc}
# toybox lspci, lsusb can handle these, which is very nice
#
set -euo pipefail

export scriptname=$(basename -- $(realpath "${0}"))
export scriptdir=$(dirname -- $(realpath "${0}"))

: ${etcdir:=""}
: ${pciidsurl:=""}
: ${usbidsurl:=""}
: ${curlopts:="-kL"}
test -z "${etcdir}" && export etcdir="$(realpath ${scriptdir}/../etc)" || true
test -z "${pciidsurl}" && export pciidsurl="https://pci-ids.ucw.cz/v2.2/pci.ids" || true
test -z "${usbidsurl}" && export usbidsurl="http://www.linux-usb.org/usb.ids" || true

function scriptecho() {
  echo "${scriptname}: ${@}"
}

test -e "${etcdir}" || {
  scriptecho "etc dir ${etcdir} not found" 1>&2
  exit 1
}

command -v curl &>/dev/null || {
  scriptecho "please install curl somewhere and add it to your PATH" 1>&2
  exit 1
}

# ${cwetc}/pci.ids
scriptecho "saving ${pciidsurl} to ${etcdir}/$(basename -- ${pciidsurl})" 1>&2
curl ${curlopts} -o "${etcdir}/$(basename -- ${pciidsurl})" "${pciidsurl}"

# ${cwetc}/usb.ids
scriptecho "saving ${usbidsurl} to ${etcdir}/$(basename -- ${usbidsurl})" 1>&2
curl ${curlopts} -o "${etcdir}/$(basename -- ${usbidsurl})" "${usbidsurl}"

# vim: set ft=bash:
