rname="nebula"
rver="1.4.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/slackhq/${rname}/archive/refs/tags/${rfile}"
rsha256="e8d79231f6100a2cd240d6a092d0dcc2bfccadffa83cb40e99b7328f6c75c2ec"
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

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  test -e \"${rbdir}\" && chmod -R u+w \"${rbdir}\" || true
  rm -rf \"${rbdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
    make BUILD_NUMBER=\"${rver}\" GOPATH=\"${rbdir}/build\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  install -m 0755 ${rname} \"${ridir}/bin/${rname}\"
  install -m 0755 ${rname}-cert \"${ridir}/bin/${rname}-cert\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
