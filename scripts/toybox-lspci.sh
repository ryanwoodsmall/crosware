#!/usr/bin/env bash
#
# toybox lspci with ${cwtop}/etc/pci.ids
#
# XXX - combine into one script with pci/usb modes, {pci,usb}.ids, detect $(basename -- "${0}) as ls{pci,usb}, use a case statement, etc.
#
set -eu
set -o pipefail

: ${cwtop:=""}
: ${cwsw:=""}
for v in cw{top,sw} ; do
  test -z "${!v}" && { echo "the ${v} environment variable is not set" 1>&2 ; exit 1 ; }
done
: ${pciids:="${cwtop}/etc/pci.ids"}
: ${toybox:="${cwsw}/toybox/current/bin/toybox"}

test -e "${toybox}" || { echo 'please install toybox' 1>&2 ; exit 1 ; }
test -e "${pciids}" || bash "${cwtop}/scripts/get-pci-usb-ids.sh" &>/dev/null

"${toybox}" lspci -i "${pciids}" "${@}"
