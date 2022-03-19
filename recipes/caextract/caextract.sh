#
# XXX - latest sha-256 sum is provided: https://curl.se/ca/cacert.pem.sha256
# XXX - if this doesn't match what we have stored, should indicate an update
#

rname="caextract"
rver="2022-03-18"
rdir="${rname}-${rver}"
rfile="cacert-${rver}.pem"
rurl="https://curl.se/ca/${rfile}"
rsha256="2d0575e481482551a6a4f9152e7d2ab4bafaeaee5f2606edb829c2fdb3713336"
rreqs=""

. "${cwrecipe}/common.sh"

for f in extract configure make clean ; do
  eval "
  function cw${f}_${rname}() {
    true
  }
  "
done
unset f

eval "
function cwmakeinstall_${rname}() {
  mkdir -p \"${ridir}\"
  rm -f \"${ridir}/${rfile}\"
  install -m 0644 \"${rdlfile}\" \"${ridir}/${rfile}\"
  ln -sf \"${rfile}\" \"${ridir}/${rname}.pem\"
  ln -sf \"${rfile}\" \"${ridir}/cacert.pem\"
  ln -sf \"${rfile}\" \"${ridir}/cert.pem\"
  ln -sf \"${rfile}\" \"${ridir}/ca-bundle.crt\"
}
"
