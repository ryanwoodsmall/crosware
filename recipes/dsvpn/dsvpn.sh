rname="dsvpn"
rver="0.1.4"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/jedisct1/${rname}/archive/refs/tags/${rfile}"
rsha256="b98604e1ca2ffa7a909bf07ca7cf0597e3baa73c116fbd257f93a4249ac9c0c5"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make OPTFLAGS=\"\${CFLAGS} -Wl,-s -g0 -Os\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/sbin\"
  make install {prefix,PREFIX}=\"\$(cwidir_${rname})\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
