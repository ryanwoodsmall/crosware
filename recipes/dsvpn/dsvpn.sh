rname="dsvpn"
rver="0.1.5"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/jedisct1/${rname}/archive/refs/tags/${rfile}"
rsha256="53c9ff2518acea188926a4f10d38929da7b61b6770d6ec00f73a4c82ff918c5e"
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
