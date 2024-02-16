#!/usr/bin/env bash
#
# toybox lsusb with ${cwtop}/etc/usb.ids
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
: ${usbids:="${cwtop}/etc/usb.ids"}
: ${toybox:="${cwsw}/toybox/current/bin/toybox"}

test -e "${toybox}" || { echo 'please install toybox' 1>&2 ; exit 1 ; }
test -e "${usbids}" || bash "${cwtop}/scripts/get-pci-usb-ids.sh" &>/dev/null

"${toybox}" lsusb -i "${usbids}" "${@}"
