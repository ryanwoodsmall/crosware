rname="bim"
rver="2.7.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/klange/${rname}/archive/${rfile}"
rsha256="5648c0f06266b3ea39f121e1dc560dc408c2360161ed4260013be0c655dad374"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  sed -i.ORIG 's/-flto//g' Makefile
  sed -i 's#^prefix=.*#prefix=${ridir}#g' Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make CPPFLAGS= LDFLAGS=-static
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make install
  \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/bin/${rname}\"
  rm -rf \"${ridir}/themes\"
  ln -sf \"${rtdir}/current/share/${rname}/themes\" \"${ridir}/themes\"
  ln -sf \"${rname}\" \"${ridir}/bin/${rname}${rver%%.*}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/bim3/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
