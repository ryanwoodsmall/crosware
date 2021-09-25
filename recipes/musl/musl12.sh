rname="musl12"
rver="1.2.1"
rdir="${rname%%12}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://musl.libc.org/releases/${rfile}"
rsha256="68af6e18539f646f9c41a3a2bb25be4a5cfa5a8f65f0bb647fd2bbfdf877e84b"
rreqs="bootstrapmake"
rprof="${cwetcprofd}/zz_${rname}.sh"
rpfile="${cwrecipe}/${rname%12}/${rname}.patches"

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
    --with-malloc=oldmalloc \
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
