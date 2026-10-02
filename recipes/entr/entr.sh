rname="entr"
rver="5.9"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/eradman/entr/archive/refs/tags/${rfile}"
rsha256="0ef2ce7db728167844a91904944cd07c7ccc6fd3041b849cad861224d106a845"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env CPPFLAGS= LDFLAGS=-static CFLAGS=\"\${CFLAGS} -Wl,-s -static\" PREFIX=\"\$(cwidir_${rname})\" ./configure
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env CPPFLAGS= LDFLAGS=-static CFLAGS=\"\${CFLAGS} -Wl,-s -static\" PREFIX=\"\$(cwidir_${rname})\" make
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env CPPFLAGS= LDFLAGS=-static CFLAGS=\"\${CFLAGS} -Wl,-s -static\" PREFIX=\"\$(cwidir_${rname})\" make install
  popd &>/dev/null
}
"


eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
