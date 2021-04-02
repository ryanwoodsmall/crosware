rname="gettexttiny"
rver="0.3.2"
rdir="gettext-tiny-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/sabotage-linux/gettext-tiny/archive/${rfile}"
rsha256="29cc165e27e83d2bb3760118c2368eadab550830d962d758e51bd36eb860f383"
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
}
"
