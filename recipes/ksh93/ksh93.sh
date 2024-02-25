rname="ksh93"
rver="1.0.8"
rdir="${rname%93}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/ksh93/ksh/archive/refs/tags/${rfile}"
rsha256="b46565045d0eb376d3e6448be6dbc214af454efc405d527f92cb81c244106c8e"
rreqs="busybox bashtiny"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    PATH=\"${cwsw}/ccache4/current/bin:${cwsw}/ccache/current/bin:${cwsw}/statictoolchain/current/bin:${cwsw}/bashtiny/current/bin:${cwsw}/busybox/current/bin\" \
    TMPDIR=\"${cwtop}/tmp\" \
      \"${cwsw}/bashtiny/current/bin/bash\" ./bin/package make \
        CC=\"\${CC} -static -Wl,-static\" \
        CCFLAGS=\"\${CFLAGS} -Wl,-s -Wl,-static -Os\" \
        LDFLAGS=\"-static -s\" \
        SHELL=\"${cwsw}/bashtiny/current/bin/bash\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  rm -f \"\$(cwidir_${rname})/bin/${rname%93}\"
  env \
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
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
