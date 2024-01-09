rname="nebula"
rver="1.8.2"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/slackhq/${rname}/archive/refs/tags/${rfile}"
rsha256="203713c58d0ec8a10df2f605af791a77a33f825454911ac3a5313ced591547fd"
rreqs="go cacertificates bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG '/^LDFLAGS/s,\$, -s -w,g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  test -e \"\$(cwbdir_${rname})\" && chmod -R u+w \"\$(cwbdir_${rname})\" || true
  rm -rf \"\$(cwbdir_${rname})\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
    CGO_ENABLED=0 \
    make BUILD_NUMBER=\"\$(cwver_${rname})\" GOPATH=\"\$(cwbdir_${rname})/build\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 ${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 0755 ${rname}-cert \"\$(cwidir_${rname})/bin/${rname}-cert\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
