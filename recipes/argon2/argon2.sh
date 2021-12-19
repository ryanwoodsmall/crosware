rname="argon2"
rver="20190702"
rdir="phc-winner-${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/P-H-C/phc-winner-argon2/archive/refs/tags/${rfile}"
rsha256="daf972a89577f8772602bf2eb38b6a3dd3d922bf5724d45e7f9589b5e830442c"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat Makefile > Makefile.ORIG
  sed -i '/^LIBRARIES/s,^LIBRARIES.*,LIBRARIES=lib${rname}.a,g' Makefile
  sed -i '/ln.*LIB_SH/s, ln , echo ln ,g' Makefile
  sed -i 's,-march=,-mtune=,g' Makefile
  sed -i 's,-O3,-Os,g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} \
    PREFIX=\"${ridir}\" \
    LIBRARY_REL=lib \
    ARGON2_VERSION=\"${rver}\" \
    OPTTARGET=generic \
    PC_EXTRA_LIBS= \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install \
    PREFIX=\"${ridir}\" \
    LIBRARY_REL=lib \
    ARGON2_VERSION=\"${rver}\" \
    OPTTARGET=generic \
    PC_EXTRA_LIBS=
  sed -i 's,^prefix=.*,prefix=${rtdir}/current,g' \"${ridir}/lib/pkgconfig/lib${rname}.pc\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
