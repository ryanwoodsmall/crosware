#
# this is cheating
#
rname="cacertificates"
rver="20190108-r0"
rdir="${rname}-${rver}"
rfile="ca-certificates-cacert-${rver}.apk"
rurl="https://mirrors.edge.kernel.org/alpine/v3.10/main/x86_64/${rfile}"
rsha256="9f9fceb0b830cc0c50d2dea4cadde01a453a36e1db6aa58bb0f713bca9acfc9d"
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
  rm -f \"${cwetc}/ssl/cert.pem\"
  rm -f \"${cwetc}/ssl/certs/ca-bundle.crt\"
  ln -sf \"${ridir}/etc/ssl/cert.pem\" \"${cwetc}/ssl/\"
  ln -sf \"${cwetc}/ssl/cert.pem\" \"${cwetc}/ssl/certs/ca-bundle.crt\"
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
