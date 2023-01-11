#
# this is cheating
# XXX - move to https://mirrors.edge.kernel.org/alpine/v3.12/main/x86_64/ca-certificates-bundle-20191127-r3.apk
# XXX - ca-certificates.crt vs cert.pem
# XXX - move to curl cacert https://curl.haxx.se/docs/caextract.html
#
rname="cacertificates"
rver="20220614-r4"
rdir="${rname}-${rver}"
rfile="ca-certificates-bundle-${rver}.apk"
#rfile="ca-certificates-cacert-${rver}.apk"
#rurl="https://mirrors.edge.kernel.org/alpine/v3.11/main/x86_64/${rfile}"
rurl="https://mirrors.edge.kernel.org/alpine/v3.17/main/x86_64/${rfile}"
rsha256="afcc0a285b823f73526c1995cf9ce71f91fc99ce0969a3494926df94e2589e68"
rreqs=""
rdlfile="${cwdl}/${rname}/${rfile}.tar.gz"

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwextract_${rname}() {
  cwmkdir \"\$(cwidir_${rname})\"
  pushd \"\$(cwidir_${rname})\" >/dev/null 2>&1
  cwextract \"\$(cwdlfile_${rname})\" \"\$(cwidir_${rname})\"
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
