rname="ninja"
rver="1.12.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}-build/${rname}/archive/${rfile}"
rsha256="821bdff48a3f683bc4bb3b6f0b5fe7b2d647cf65d52aeb63328c91a6c6df285a"
rreqs="make python3"

. "${cwrecipe}/common.sh"

cwstubfunc "cwmake_${rname}"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  \"${cwsw}/python3/current/bin/python3\" ./configure.py --bootstrap
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 \"${rname}\" \"\$(cwidir_${rname})/bin/\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
