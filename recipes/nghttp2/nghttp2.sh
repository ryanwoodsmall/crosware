#
# XXX - this is the bare lib only!
# XXX - apps need(?)...
# XXX - libxml2
# XXX - libev
# XXX - zlib
# XXX - ... and NEED separate openssl, libressl and wolfssl variants for apps, examples
#
rname="nghttp2"
rver="1.64.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/nghttp2/nghttp2/releases/download/v${rver}/${rfile}"
rsha256="20e73f3cf9db3f05988996ac8b3a99ed529f4565ca91a49eb0550498e10621e8"
rreqs="bootstrapmake busybox bashtiny slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"\$(echo ${cwsw}/{bashtiny,busybox,bootstrapmake,slibtool,ccache{,4},statictoolchain}/current/bin | tr ' ' ':')\" \
    \"${cwsw}/bashtiny/current/bin/bash\" \
      ./configure \
        --disable-app \
        --disable-examples \
        --enable-lib-only \
          ${cwconfigureprefix} \
          ${cwconfigurelibopts} \
          ${rconfigureopts} \
          ${rcommonopts} \
            LDFLAGS=-static \
            CPPFLAGS= \
            PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make -j${cwmakejobs} ${rlibtool} \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool} \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
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
