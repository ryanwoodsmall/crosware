#
# this is cheating
#
rname="cacertificates"
rver="20191127-r0"
rdir="${rname}-${rver}"
rfile="ca-certificates-cacert-${rver}.apk"
rurl="https://mirrors.edge.kernel.org/alpine/v3.11/main/x86_64/${rfile}"
rsha256="b14b6845471adc9438f4a836c6a0b583c701a3e982318a9654777dcc5bfa95e3"
rreqs=""
rdlfile="${cwdl}/${rname}/${rfile}.tar.gz"

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  cwmkdir \"${ridir}\"
  pushd \"${ridir}\" >/dev/null 2>&1
  cwextract \"${rdlfile}\" \"${ridir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${cwetc}/ssl/certs\"
  cwmkdir \"${cwetc}/libressl/certs\"
  rm -f \"${cwetc}/ssl/cert.pem\"
  rm -f \"${cwetc}/libressl/cert.pem\"
  rm -f \"${cwetc}/ssl/certs/ca-bundle.crt\"
  rm -f \"${cwetc}/libressl/certs/ca-bundle.crt\"
  ln -sf \"${rtdir}/current/etc/ssl/cert.pem\" \"${cwetc}/ssl/\"
  ln -sf \"${rtdir}/current/etc/ssl/cert.pem\" \"${cwetc}/libressl/\"
  ln -sf \"${cwetc}/ssl/cert.pem\" \"${cwetc}/ssl/certs/ca-bundle.crt\"
  ln -sf \"${cwetc}/ssl/cert.pem\" \"${cwetc}/libressl/certs/ca-bundle.crt\"
}
"

eval "
function cwuninstall_${rname}() {
  pushd \"${cwsw}\" >/dev/null 2>&1
  rm -rf \"${rname}\"
  rm -f \"${cwetc}/ssl/cert.pem\"
  rm -f \"${cwetc}/ssl/certs/ca-bundle.crt\"
  rm -f \"${rprof}\"
  rm -f \"${cwvarinst}/${rname}\"
  popd >/dev/null 2>&1
}
"

for f in configure make ; do
eval "
function cw${f}_${rname}() {
  true
}
"
done
unset f
