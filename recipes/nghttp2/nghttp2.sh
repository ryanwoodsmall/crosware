#
# XXX - this is the bare lib only!
# XXX - apps need(?)...
# XXX - libxml2
# XXX - libev
# XXX - zlib
# XXX - ... and NEED separate openssl and libressl variants for apps, examples
#
rname="nghttp2"
rver="1.60.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="ca2333c13d1af451af68de3bd13462de7e9a0868f0273dea3da5bc53ad70b379"
rreqs="bootstrapmake busybox slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure \
    --disable-app \
    --disable-examples\
    ${cwconfigureprefix} \
    ${cwconfigurelibopts} \
    ${rconfigureopts} \
    ${rcommonopts} \
      CPPFLAGS= \
      LDFLAGS=-static \
      PKG_CONFIG_LIBDIR= \
      PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool} \
    CPPFLAGS= \
    LDFLAGS=-static \
    PKG_CONFIG_LIBDIR= \
    PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool} \
    CPPFLAGS= \
    LDFLAGS=-static \
    PKG_CONFIG_LIBDIR= \
    PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
