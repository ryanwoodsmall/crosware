rname="libxslt"
rver="1.1.32"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="ftp://xmlsoft.org/${rname}/${rfile}"
rsha256="526ecd0abaf4a7789041622c3950c0e7f2c4c8835471515fd77eec684a355460"
rreqs="make libgcrypt libxml2 slibtool xz zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/libxml2/current/bin:${cwsw}/libgcrypt/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
      --with-libxml-prefix=\"${cwsw}/libxml2/current\" \
      --without-python \
        LIBS='-llzma -lz'
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} LIBTOOL=\"${cwsw}/slibtool/current/bin/slibtool-static -all-static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install LIBTOOL=\"${cwsw}/slibtool/current/bin/slibtool-static -all-static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
