rname="ninja"
rver="1.13.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}-build/${rname}/archive/${rfile}"
rsha256="f0055ad0369bf2e372955ba55128d000cfcc21777057806015b45e4accbebf23"
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
