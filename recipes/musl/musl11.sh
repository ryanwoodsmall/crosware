rname="musl11"
rver="1.1.24"
rdir="${rname%%11}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://musl.libc.org/releases/${rfile}"
rsha256="1370c9a812b2cf2a7d92802510cca0058cc37e66a7bedd70051f0a34015022a3"
rreqs="bootstrapmake"
rprof="${cwetcprofd}/zz_${rname}.sh"
rpfile="${cwrecipe}/${rname%11}/${rname}.patches"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's#\\\$ldso#${rtdir}/current/lib/ld.so#g' tools/musl-gcc.specs.sh
  ./configure ${cwconfigureprefix} \
    --syslibdir=\"${ridir}/lib\" \
    --enable-debug \
    --enable-warnings \
    --enable-wrapper=gcc \
    --enable-shared \
    --enable-static \
      CFLAGS='-fPIC' \
      CPPFLAGS= \
      CXXFLAGS= \
      LDFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install
  ln -sf musl-gcc \"${ridir}/bin/cc\"
  ln -sf musl-gcc \"${ridir}/bin/gcc\"
  ln -sf musl-gcc \"${ridir}/bin/musl-cc\"
  ln -sf musl-gcc \"${ridir}/bin/${statictoolchain_triplet[${karch}]}-cc\"
  ln -sf musl-gcc \"${ridir}/bin/${statictoolchain_triplet[${karch}]}-gcc\"
  ln -sf libc.so \"${ridir}/lib/ldd\"
  ln -sf \"${rtdir}/current/lib/ldd\" \"${ridir}/bin/musl-ldd\"
  ln -sf libc.so \"${ridir}/lib/ld.so\"
  sed -i.ORIG 's#${ridir}#${rtdir}/current#g' \"${ridir}/lib/musl-gcc.specs\"
  popd >/dev/null 2>&1
}
"
