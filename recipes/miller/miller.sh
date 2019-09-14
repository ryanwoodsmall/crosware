rname="miller"
rver="5.6.0"
rdir="mlr-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/johnkerl/${rname}/releases/download/v${rver}/${rfile}"
rsha256="325f9acabd5b1b00663b03c6454f609981825ba12d3f82d000772399a28a1ff2"
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
