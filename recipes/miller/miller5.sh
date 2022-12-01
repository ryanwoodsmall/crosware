rname="miller5"
rver="5.10.4"
rdir="${rname%5}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/johnkerl/miller/archive/refs/tags/${rfile}"
rsha256="89075e4f9571562cfe2b9af35e4428bdf5740b09aa65fab3838381075f9436c2"
rreqs="make sed flex"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i 's/-g -pg//g' c/Makefile.am c/Makefile.in
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  ln -sf mlr \"${ridir}/bin/mlr5\"
  ln -sf mlr \"${ridir}/bin/${rname}\"
  ln -sf mlr \"${ridir}/bin/${rname%5}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
