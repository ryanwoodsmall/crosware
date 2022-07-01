rname="nebula"
rver="1.6.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/slackhq/${rname}/archive/refs/tags/${rfile}"
rsha256="b16638b99d80a4ae6373f7757a0064dc0defd3f9e165617e7b5c3be9e64d3605"
rreqs="go cacertificates bootstrapmake"

. "${cwrecipe}/common.sh"

# XXX - segfaults on compile/link for riscv64, problem with my go? qemu? cross-compile problem?
if [[ ${karch} =~ ^riscv64 ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"recipe ${rname} does not support architecture ${karch}\"
}
"
fi

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
  test -e \"\$(cwbdir_${rname})/\" || return 0
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
