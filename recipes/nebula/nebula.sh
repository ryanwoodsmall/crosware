rname="nebula"
rver="1.6.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/slackhq/${rname}/archive/refs/tags/${rfile}"
rsha256="9c343d998d2eab9473c3bf73d434b8a382d90b1f73095dd1114ecaf2e1c0970f"
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
