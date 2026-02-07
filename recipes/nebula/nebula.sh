rname="nebula"
rver="1.10.3"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/slackhq/nebula/archive/refs/tags/${rfile}"
rsha256="12972f5a1dc37b89dff6af91685f7f7eb643b7f75da760c036d1e8d850387e54"
rreqs="go cacertificates bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG '/^LDFLAGS/s,\$, -s -w,g' Makefile
  popd &>/dev/null
}
"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  test -e \"\$(cwbdir_${rname})\" && chmod -R u+w \"\$(cwbdir_${rname})\" || true
  rm -rf \"\$(cwbdir_${rname})\"
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
    CGO_ENABLED=0 \
    make BUILD_NUMBER=\"\$(cwver_${rname})\" GOPATH=\"\$(cwbdir_${rname})/build\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 ${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 0755 ${rname}-cert \"\$(cwidir_${rname})/bin/${rname}-cert\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
