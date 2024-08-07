rname="ksh93"
rver="1.0.10"
rdir="${rname%93}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/ksh93/ksh/archive/refs/tags/${rfile}"
rsha256="9f4c7a9531cec6941d6a9fd7fb70a4aeda24ea32800f578fd4099083f98b4e8a"
rreqs="busybox bashtiny"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    AST_NO_DYLIB=1 \
    PATH=\"${cwsw}/ccache4/current/bin:${cwsw}/ccache/current/bin:${cwsw}/statictoolchain/current/bin:${cwsw}/bashtiny/current/bin:${cwsw}/busybox/current/bin\" \
    TMPDIR=\"${cwtop}/tmp\" \
      \"${cwsw}/bashtiny/current/bin/bash\" ./bin/package make \
        CC=\"\${CC} -static -Wl,-static\" \
        CCFLAGS=\"\${CFLAGS} -Wl,-s -Wl,-static -Os\" \
        LDFLAGS=\"-static -s\" \
        SHELL=\"${cwsw}/bashtiny/current/bin/bash\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  rm -f \"\$(cwidir_${rname})/bin/${rname%93}\"
  env \
    AST_NO_DYLIB=1 \
    PATH=\"${cwsw}/ccache4/current/bin:${cwsw}/ccache/current/bin:${cwsw}/statictoolchain/current/bin:${cwsw}/bashtiny/current/bin:${cwsw}/busybox/current/bin\" \
    TMPDIR=\"${cwtop}/tmp\" \
      \"${cwsw}/bashtiny/current/bin/bash\" ./bin/package install \"\$(cwidir_${rname})\" \
        CC=\"\${CC} -static -Wl,-static\" \
        CCFLAGS=\"\${CFLAGS} -Wl,-s -Wl,-static -Os\" \
        LDFLAGS=\"-static -s\" \
        SHELL=\"${cwsw}/bashtiny/current/bin/bash\"
  cat \"\$(cwidir_${rname})/bin/${rname%93}\" > \"\$(cwidir_${rname})/bin/${rname}\"
  chmod 755 \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/${rname%93}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
