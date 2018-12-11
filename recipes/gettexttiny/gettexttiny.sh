rname="gettexttiny"
rver="0.3.1"
rdir="gettext-tiny-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/sabotage-linux/gettext-tiny/archive/${rfile}"
rsha256="654dcd52f2650476c8822b60bee89c20a0aa7f6a1bf6001701eeacd71a9e388b"
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
