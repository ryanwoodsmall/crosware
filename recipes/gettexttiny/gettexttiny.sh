rname="gettexttiny"
rver="0.3.3"
rdir="gettext-tiny-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/sabotage-linux/gettext-tiny/archive/${rfile}"
rsha256="daff8b4a7863745710ec0b02657fd20bda2d90398f54945751259bb94d6ebffd"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" &>/dev/null
  sed -i.ORIG \"s#^prefix=.*#prefix=${ridir}#g\" Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" &>/dev/null
  env LIBINTL=MUSL make -j${cwmakejobs}
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" &>/dev/null
  env LIBINTL=MUSL make install
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
