#
# XXX - latest sha-256 sum is provided: https://curl.se/ca/cacert.pem.sha256
# XXX - if this doesn't match what we have stored, should indicate an update
#

rname="caextract"
rver="2022-03-29"
rdir="${rname}-${rver}"
rfile="cacert-${rver}.pem"
rurl="https://curl.se/ca/${rfile}"
rsha256="1979e7fe618c51ed1c9df43bba92f977a0d3fe7497ffa2a5e80dfc559a1e5a29"
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
