rname="netbsdwtf"
rver="fc5588bdd1c45dc812e39bc8ac75084424c67de8"
rdir="netbsd-wtf-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/void-linux/netbsd-wtf/archive/${rfile}"
rsha256="9b08eb35cd5776909c6f1c5f2f2ecb9fec8b5f477ec49c3ca986de14ded24b4c"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make PREFIX=\"\$(cwidir_${rname})\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install PREFIX=\"\$(cwidir_${rname})\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
