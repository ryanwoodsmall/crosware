rname="gronawk"
rver="0.3.0"
rdir="gron.awk-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/xonixx/gron.awk/archive/refs/tags/${rfile}"
rsha256="bef65299cad620a8c5e58a89b79199b6c456c56614ea4d3c869ebbe5b2a099f6"
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 gron.awk \"\$(cwidir_${rname})/bin/\"
  ln -sf gron.awk \"\$(cwidir_${rname})/bin/${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
