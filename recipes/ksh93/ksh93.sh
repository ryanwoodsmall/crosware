#
# XXX - ash broken on riscv64?
#

rname="ksh93"
rver="1.0.3"
rdir="${rname%93}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/ksh/archive/refs/tags/${rfile}"
rsha256="e554a96ecf7b64036ecb730fcc2affe1779a2f14145eb6a95d0dfe8b1aba66b5"
rreqs="busybox dashtiny"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    PATH=\"${cwsw}/ccache4/current/bin:${cwsw}/ccache/current/bin:${cwsw}/statictoolchain/current/bin:${cwsw}/dashtiny/current/bin:${cwsw}/busybox/current/bin\" \
      \"${cwsw}/dashtiny/current/bin/dash\" ./bin/package make \
        CC=\"\${CC} -static -Wl,-static\" \
        CCFLAGS=\"\${CFLAGS} -Wl,-s -Wl,-static -Os\" \
        LDFLAGS=\"-static -s\" \
        SHELL=\"${cwsw}/dashtiny/current/bin/dash\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  rm -f \"\$(cwidir_${rname})/bin/${rname%93}\"
  env \
    PATH=\"${cwsw}/ccache4/current/bin:${cwsw}/ccache/current/bin:${cwsw}/statictoolchain/current/bin:${cwsw}/dashtiny/current/bin:${cwsw}/busybox/current/bin\" \
      \"${cwsw}/dashtiny/current/bin/dash\" ./bin/package install \"\$(cwidir_${rname})\" \
        CC=\"\${CC} -static -Wl,-static\" \
        CCFLAGS=\"\${CFLAGS} -Wl,-s -Wl,-static -Os\" \
        LDFLAGS=\"-static -s\" \
        SHELL=\"${cwsw}/dashtiny/current/bin/dash\"
  cat \"\$(cwidir_${rname})/bin/${rname%93}\" > \"\$(cwidir_${rname})/bin/${rname}\"
  chmod 755 \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/${rname%93}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
