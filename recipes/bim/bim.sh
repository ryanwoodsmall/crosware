rname="bim"
rver="2.7.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/klange/${rname}/archive/${rfile}"
rsha256="5648c0f06266b3ea39f121e1dc560dc408c2360161ed4260013be0c655dad374"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's/-flto//g' Makefile
  sed -i 's#^prefix=.*#prefix=${ridir}#g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install
  \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/bin/${rname}\"
  rm -rf \"${ridir}/themes\"
  ln -sf \"${rtdir}/current/share/${rname}/themes\" \"${ridir}/themes\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
