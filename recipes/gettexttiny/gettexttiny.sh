rname="gettexttiny"
rver="0.3.0"
rdir="gettext-tiny-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/sabotage-linux/gettext-tiny/archive/${rfile}"
rsha256="2afebb8731312b13990dbf375f77cf4353df6540577f64b9c6d2f419b8d1b5a7"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG \"s#^prefix=.*#prefix=${ridir}#g\" Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env LIBINTL=MUSL make -j${cwmakejobs}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env LIBINTL=MUSL make install
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
