rname="miller"
rver="5.10.0"
rdir="mlr-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/johnkerl/${rname}/releases/download/v${rver}/${rfile}"
rsha256="1e964a97ee0333a57966a2e8d1913aebc28875e9bee3effbbc51506ca5389200"
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
