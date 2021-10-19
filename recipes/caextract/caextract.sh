rname="caextract"
rver="2021-09-30"
rdir="${rname}-${rver}"
rfile="cacert-${rver}.pem"
rurl="https://curl.se/ca/cacert-2021-09-30.pem"
rsha256="f524fc21859b776e18df01a87880efa198112214e13494275dbcbd9bcb71d976"
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
