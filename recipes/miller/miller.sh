rname="miller"
rver="5.5.0"
rdir="mlr-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/johnkerl/${rname}/releases/download/v${rver}/${rfile}"
rsha256="0db9329f9e7c1a65f834dc357cd459ea991c32d60633e9d97db188b11daef31a"
rreqs="make sed flex"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i 's/-g -pg//g' c/Makefile.am c/Makefile.in
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install
  ln -sf \"${rtdir}/current/bin/mlr\" \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
