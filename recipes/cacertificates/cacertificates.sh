#
# this is cheating
# XXX - move to https://mirrors.edge.kernel.org/alpine/v3.12/main/x86_64/ca-certificates-bundle-20191127-r3.apk
# XXX - ca-certificates.crt vs cert.pem
# XXX - move to curl cacert https://curl.haxx.se/docs/caextract.html
# XXX - alpine keeps removing .apk files, getting real old
#
rname="cacertificates"
rver="20261020-r0"
rdir="${rname}-${rver}"
rfile="ca-certificates-bundle-${rver}.apk"
#rfile="ca-certificates-cacert-${rver}.apk"
#rurl="https://mirrors.edge.kernel.org/alpine/v3.11/main/x86_64/${rfile}"
#rurl="https://mirrors.edge.kernel.org/alpine/v3.17/main/x86_64/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/alpine/${rfile}"
rsha256="bb008f6d214b6af7576324659856fb63dc8dcb4373f8345ff706388696f1254d"
rreqs=""
rdlfile="${cwdl}/${rname}/${rfile}.tar.gz"

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwextract_${rname}() {
  cwmkdir \"\$(cwidir_${rname})\"
  pushd \"\$(cwidir_${rname})\" &>/dev/null
  cwextract \"\$(cwdlfile_${rname})\" \"\$(cwidir_${rname})\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${cwetc}/ssl/certs\"
  cwmkdir \"${cwetc}/libressl/certs\"
  for c in \
    \"${cwetc}/ssl/cert.pem\" \
    \"${cwetc}/ssl/certs/ca-bundle.crt\" \
    \"${cwetc}/libressl/cert.pem\" \
    \"${cwetc}/libressl/certs/ca-bundle.crt\"
  do
    test -e \${c} && test -L \${c} && rm -f \${c} || true
    test -e \${c} && test -f \${c} && mv \${c}{,.PRE-\${TS}} || true
  done
  ln -sf \"${rtdir}/current/etc/ssl/cert.pem\" \"${cwetc}/ssl/\"
  ln -sf \"${rtdir}/current/etc/ssl/cert.pem\" \"${cwetc}/libressl/\"
  ln -sf \"${cwetc}/ssl/cert.pem\" \"${cwetc}/ssl/certs/ca-bundle.crt\"
  ln -sf \"${cwetc}/libressl/cert.pem\" \"${cwetc}/libressl/certs/ca-bundle.crt\"
  cwmkdir \"${cwetc}/ca-certs/${rname}\"
  rm -f \"${cwetc}/ca-certs/${rname}/cert.pem\" || true
  install -D -m 0644 \"\$(cwidir_${rname})/etc/ssl/cert.pem\" \"${cwetc}/ca-certs/${rname}/cert.pem\"
}
"

eval "
function cwuninstall_${rname}() {
  pushd \"${cwsw}\" &>/dev/null
  cwstderrecho 'i will not uninstall the ${rname} package, sorry'
  cwstderrecho 'overwrite files in ${cwetc}/{libre,}ssl/{certs/,} manually'
  : rm -rf \"${rname}\"
  : rm -f \"${cwetc}/ssl/cert.pem\"
  : rm -f \"${cwetc}/ssl/certs/ca-bundle.crt\"
  : rm -f \"${cwetc}/libressl/cert.pem\"
  : rm -f \"${cwetc}/libressl/certs/ca-bundle.crt\"
  : rm -f \"${rprof}\"
  : rm -f \"${cwvarinst}/${rname}\"
  popd &>/dev/null
}
"
