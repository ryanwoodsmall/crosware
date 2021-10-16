#
# this is cheating
# XXX - move to https://mirrors.edge.kernel.org/alpine/v3.12/main/x86_64/ca-certificates-bundle-20191127-r3.apk
# XXX - ca-certificates.crt vs cert.pem
# XXX - move to curl cacert https://curl.haxx.se/docs/caextract.html
#
rname="cacertificates"
rver="20191127-r5"
rdir="${rname}-${rver}"
#rfile="ca-certificates-cacert-${rver}.apk"
#rurl="https://mirrors.edge.kernel.org/alpine/v3.11/main/x86_64/${rfile}"
rfile="ca-certificates-bundle-${rver}.apk"
rurl="https://mirrors.edge.kernel.org/alpine/v3.14/main/x86_64/${rfile}"
rsha256="318d47496c9807f78ac697bfcb5de5184450aadce8df4766df7a3db165bda2dd"
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
